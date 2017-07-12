module UsaliaBot
  module Scheduler
    include UsaliaBot::Redis

    TEMP_CHANNEL_LIFESPAN = 3600.freeze # 1 hour

    def self.run(bot)
      scheduler = Rufus::Scheduler.new

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
    end
  end
end
