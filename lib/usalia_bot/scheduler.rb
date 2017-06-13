module UsaliaBot
  module Scheduler
    include UsaliaBot::Redis

    TEMP_CHANNEL_LIFESPAN = 3600.freeze # 1 hour

    def self.run(bot)
      scheduler = Rufus::Scheduler.new

      scheduler.every('5m') do
        channels = JSON.parse(Redis.get_json('temp-channels'))

        channels.each do |user_id, channel|
          expiration_time = Time.parse(channel['created_at']) + TEMP_CHANNEL_LIFESPAN
          channel = bot.channel(channel['channel_id'])

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
