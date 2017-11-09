module UsaliaBot
  module HelperMethods
    MENTION = /<@!?#{CONFIG.client_id}>/.freeze
    EMOJI_REGEX = /(#{File.read('data/emoji_list.txt').chomp})|(?:<:(\w+:\d+)>)/.freeze

    def author_display_name(event)
      event.channel.pm? ? event.author.username : event.server.member(event.author).display_name
    end

    def bot_mention
      MENTION
    end

    def capitalize(str)
      str.sub(/^./, &:upcase)
    end

    def delete_request(message, reply, time = 20)
      return if message.channel.pm?

      sleep(time)
      safe_delete(message)
      safe_delete(reply)
    end

    def emoji_regex
      EMOJI_REGEX
    end

    def message_mentions(message, include_author: true, include_bot: false, readable: false)
      # All Users mentioned
      mentions = message.mentions

      # except the bot (unless specificed otherwise)
      mentions.reject!(&:current_bot?) unless include_bot

      # including users of individual roles (optionally only those who can read the message)
      mentions += role_mention_members(message, readable)

      # and the author of the message (optional)
      mentions << message.author if include_author

      # converted to Members if the message is not a DM
      unless message.channel.pm?
        server = message.channel.server
        mentions.map! { |user| user.on(server) }
      end

      mentions.uniq
    end

    def request?(event)
      CONFIG.request_channel_ids.include?(event.channel.id)
    end

    def safe_delete(message)
      message.channel.load_message(message.id)&.delete
    end

    private
    def role_mention_members(message, readable = false)
      members = message.role_mentions.flat_map(&:members)
      members.keep_if { |member| member.permission?(:read_messages, message.channel) } if readable
      members
    end
  end
end
