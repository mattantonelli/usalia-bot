module UsaliaBot
  module Scheduler
    MEMBER_PURGE_TIME = 604800.freeze # 1 week
    TEMP_CHANNEL_LIFESPAN = 3600.freeze # 1 hour

    def self.run(bot)
      scheduler = Rufus::Scheduler.new

      def scheduler.on_error(job, error)
        Discordrb::LOGGER.error(error)
        error.backtrace.each { |line| Discordrb::LOGGER.error(line) }
      end

      # Clean up temporary channels
      scheduler.cron('*/5 * * * *') do
        channels = JSON.parse(Redis.get_json('temp-channels'))

        channels.each do |user_id, details|
          channel = bot.channel(details['channel_id'])
          expiration_time = Time.parse(details['created_at']) + TEMP_CHANNEL_LIFESPAN

          # If the channel was deleted manually, or its time has expired, disband the party
          if channel.nil? || (expiration_time < Time.now && channel.users.empty?)
            UsaliaBot::Commands::Party.disband_party(bot, user_id)
          end
        end
      end

      # Purge members who have not been assigned a role
      # and delete any old introduction messages by the bot
      scheduler.cron('0 0 * * *') do
        server = bot.servers.values.first

        server.members.compact.each do |member|
          next unless join_time = member.joined_at

          if member.roles.empty? && join_time + MEMBER_PURGE_TIME < Time.now
            server.kick(member, 'No role')
          end
        end

        channel = bot.channel(CONFIG.introduction_channel_id)

        channel.history(100).each do |message|
          if message.author.current_bot? && message.timestamp < Time.now - MEMBER_PURGE_TIME
            message.delete
          end
        end
      end

      # Poll FF Logs for new reports
      scheduler.cron('*/5 * * * *') do
        FFLogs.poll(bot)
      end

      # Poll Twitch for stream updates
      scheduler.cron('*/5 * * * *') do
        Twitch.poll(bot)
      end
    end
  end
end
