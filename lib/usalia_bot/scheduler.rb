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

          # If the channel was deleted manually, remove it from redis
          if channel.nil?
            channels.delete(user_id)
            next
          end

          expiration_time = Time.parse(details['created_at']) + TEMP_CHANNEL_LIFESPAN

          # If the channel's time has expired, delete it and remove it from redis
          if expiration_time < Time.now && channel.users.empty?
            channel.delete
            channels.delete(user_id)
          end
        end

        Redis.set('temp-channels', channels.to_json)
      end
    end
  end
end
