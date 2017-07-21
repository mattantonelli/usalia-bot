module UsaliaBot
  module Scheduler
    include UsaliaBot::Redis

    MEMBER_PURGE_TIME = 604800.freeze # 1 week
    TEMP_CHANNEL_LIFESPAN = 3600.freeze # 1 hour

    def self.run(bot)
      scheduler = Rufus::Scheduler.new

      # Clean up temporary channels
      scheduler.every('5m') do
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
      scheduler.cron('0 0 * * FRI') do
        server = bot.servers.values.first

        server.members.each do |member|
          next unless join_time = member.joined_at

          if member.roles.empty? && join_time + MEMBER_PURGE_TIME < Time.now
            server.kick(member, 'No role')
          end
        end
      end
    end
  end
end
