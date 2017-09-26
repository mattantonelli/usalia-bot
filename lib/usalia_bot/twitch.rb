module UsaliaBot
  module Twitch
    extend self

    TWITCH_API_URL = 'https://api.twitch.tv/kraken'.freeze
    TWITCH_HEADERS = { client_id: CONFIG.twitch_client_id, accept: 'application/vnd.twitchtv.v5+json' }.freeze
    TWITCH_DEFAULT_THUMBNAIL = 'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png'

    def poll(bot)
      streams = live_streams(Redis.hkeys('twitch-status'))
      stream_channel_ids = streams.map { |stream| stream[:channel][:_id].to_s }
      current_streams = Redis.hgetall('twitch-status').select { |id, status| status == 'active'}
      channel = bot.channel(CONFIG.twitch_channel_id)

      new_streams = streams.reject { |stream| current_streams.keys.include?(stream[:channel][:_id].to_s) }
      ended_streams = current_streams.select { |id, status| !stream_channel_ids.include?(id) }

      new_streams.each do |stream|
        id = stream[:channel][:_id].to_s
        send_twitch_embed(stream, channel) if new_stream?(id, :twitch)
        set_status(id, :twitch, 'active')
        set_time(id, :twitch)
        channel.send_message("Stream started for `#{id}`")
      end

      ended_streams.each do |id, _|
        set_status(id, :twitch, 'inactive')
        set_time(id, :twitch)
        channel.send_message("Stream ended for `#{id}`")
      end
    end

    def stream_event(event)
      id = event.user.id

      if event.url
        send_stream_embed(event) if new_stream?(id, :stream)
        set_status(id, :stream, 'active')
        set_time(id, :stream)
      elsif stream_active?(id, :stream)
        set_status(id, :stream, 'inactive')
        set_time(id, :stream)
      end
    end

    def enable_stream(id, command)
      Redis.hset("#{command}-status", id, 'inactive')
      Redis.hset("#{command}-time", id, Time.at(0))
    end

    def disable_stream(id, command)
      Redis.hdel("#{command}-status", id)
      Redis.hdel("#{command}-time", id)
    end

    def stream_status(id, command)
      Redis.hexists?("#{command}-status", id) ? 'enabled' : 'disabled'
    end

    def user(username)
      url = "#{TWITCH_API_URL}/users?login=#{username}"
      response = RestClient.get(url, TWITCH_HEADERS)
      body = JSON.parse(response.body, symbolize_names: true)
      body[:users].first
    end

    private
    def send_stream_embed(event)
      channel = event.bot.channel(CONFIG.twitch_channel_id)
      display_name = event.user.on(event.server).display_name
      username = event.url.split('/').last
      thumbnail = user(username)[:logo]

      send_embed(channel, event.url, event.game, display_name, event.user.avatar_url, thumbnail, Time.now)
    end

    def send_twitch_embed(stream, server_channel)
      url = stream[:channel][:url]
      game = stream[:game]
      display_name = stream[:channel][:display_name]
      thumbnail = stream[:channel][:logo]
      timestamp = Time.parse(stream[:created_at])

      send_embed(server_channel, url, game, display_name, nil, thumbnail, timestamp)
    end

    def new_stream?(id, namespace)
      last_update = Time.parse(Redis.hget("#{namespace}-time", id))
      Redis.hget("#{namespace}-status", id) == 'inactive' && Time.now > last_update + 3600
    end

    def stream_active?(id, namespace)
      Redis.hget("#{namespace}-status", id) == 'active'
    end

    def set_status(id, namespace, status)
      Redis.hset("#{namespace}-status", id, status)
    end

    def set_time(id, namespace)
      Redis.hset("#{namespace}-time", id, Time.now)
    end

    def live_streams(channels)
      channels.each_slice(100).flat_map do |channel_ids|
        url = "#{TWITCH_API_URL}/streams?channel=#{channel_ids.join(',')}&stream_type=live"
        response = RestClient.get(url, TWITCH_HEADERS)
        body = JSON.parse(response.body, symbolize_names: true)
        body[:streams]
      end
    end

    def send_embed(channel, url, game, display_name, icon, thumbnail, timestamp)
      description = game.empty? ? "Now streaming\n#{url}" : "Now streaming: **#{game}**\n#{url}"

      channel.send_embed do |embed|
        embed.colour = 0x593695
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: display_name, icon_url: icon)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: thumbnail || TWITCH_DEFAULT_THUMBNAIL)
        embed.description = description
        embed.timestamp = timestamp
      end
    end
  end
end
