module UsaliaBot
  module HelperMethods
    MENTION = /<@!?#{CLIENT_ID}>/

    def officer?(event)
      event.user.on(event.channel.server).role?(OFFICER_ROLE)
    end

    def request?(event)
      REQUEST_CHANNELS.include?(event.channel.id)
    end

    def role_mention_members(message, readable = false)
      members = message.role_mentions.flat_map(&:members)
      members.keep_if { |member| member.permission?(:read_messages, message.channel) } if readable
      members
    end
  end
end
