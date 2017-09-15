module UsaliaBot
  module Events
    module Stream
      extend Discordrb::EventContainer
      extend UsaliaBot::HelperMethods
      include UsaliaBot::Redis

      TWITCH_API_URL = 'https://api.twitch.tv/kraken'.freeze
      TWITCH_HEADERS = { client_id: CONFIG.twitch_client_id, accept: 'application/vnd.twitchtv.v5+json' }.freeze
      DEFAULT_THUMBNAIL = 'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png'

      playing do |event|
        user = event.user

        # User must first enable stream updates with the "stream on" command
        next unless stream_enabled?(user)

        url = event.url

        if url
          send_embed(event) if new_stream?(user)
          set_status(user, 'active')
          set_time(user)
        elsif stream_active?(user)
          set_status(user, 'inactive')
          set_time(user)
        end
      end

      private
      def self.send_embed(event)
        url = event.url
        game = event.game
        name = event.user.on(event.server).display_name
        channel = event.bot.channel(CONFIG.twitch_channel_id)
        thumbnail = fetch_thumbnail(url)

        channel.send_embed do |embed|
          embed.colour = 0x593695
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: name, icon_url: event.user.avatar_url)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: thumbnail)
          embed.description = "Now streaming: **#{game}**\n#{url}"
          embed.timestamp = Time.now
        end
      end

      def self.fetch_thumbnail(stream_url)
        url = "#{TWITCH_API_URL}/users?login=#{stream_url.split('/').last}"
        response = RestClient.get(url, TWITCH_HEADERS)
        body = JSON.parse(response.body, symbolize_names: true)
        body[:users][0][:logo] || DEFAULT_THUMBNAIL
      end

      def self.stream_enabled?(user)
        Redis.hexists?('stream-status', user.id)
      end

      def self.new_stream?(user)
        last_update = Time.parse(Redis.hget('stream-time', user.id))
        Redis.hget('stream-status', user.id) == 'inactive' && Time.now > last_update + 3600
      end

      def self.stream_active?(user)
        Redis.hget('stream-status', user.id) == 'active'
      end

      def self.set_status(user, status)
        Redis.hset('stream-status', user.id, status)
      end

      def self.set_time(user)
        Redis.hset('stream-time', user.id, Time.now)
      end
    end
  end
end
