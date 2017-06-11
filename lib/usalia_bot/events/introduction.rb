module UsaliaBot
  module Events
    module Introduction
      extend Discordrb::EventContainer

      MESSAGE = "Welcome to the SLDR Discord server, plip! If you're a member of SLDR, " \
                'or just a friend of the FC, please take a second to introduce yourself ' \
                'and tell us your in-game name. This will help us get to know you and ' \
                "make sure you're assigned the proper role on the server."

      member_join do |event|
        channel = event.bot.channel(CONFIG.introduction_channel_id)
        channel.send_message("#{event.user.mention} #{MESSAGE}")
      end
    end
  end
end
