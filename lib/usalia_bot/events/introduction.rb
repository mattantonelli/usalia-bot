module UsaliaBot
  module Events
    module Introduction
      extend Discordrb::EventContainer

      MESSAGE = 'Welcome to the server, plip! Please take a second to introduce yourself ' \
                'and tell us your in-game name. This will help us get to know you and ' \
                "make sure you're assigned the proper role on the server.".freeze

      member_join do |event|
        channel_id = (event.server.channels.map(&:id) & CONFIG.introduction_channel_ids).first

        if channel_id
          channel = event.bot.channel(channel_id)
          channel.send_message("#{event.user.mention} #{MESSAGE}")
        end
      end
    end
  end
end
