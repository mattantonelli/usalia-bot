module UsaliaBot
  module HelperMethods
    MENTION = /<@!?#{CONFIG.client_id}>/

    def author_display_name(event)
      event.channel.pm? ? event.author.username : event.server.member(event.author).display_name
    end

    def officer?(event)
      event.user.on(event.channel.server).role?(CONFIG.officer_role_id)
    end

    def request?(event)
      CONFIG.request_channel_ids.include?(event.channel.id)
    end

    def role_mention_members(message, readable = false)
      members = message.role_mentions.flat_map(&:members)
      members.keep_if { |member| member.permission?(:read_messages, message.channel) } if readable
      members
    end
  end
end
