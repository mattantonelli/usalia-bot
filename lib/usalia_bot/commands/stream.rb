module UsaliaBot
  module Commands
    module Stream
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods
      include UsaliaBot::Redis
      include UsaliaBot::Twitch

      description = 'Broadcasts when you start streaming. Your Discord account must be connected to Twitch.'

      command(:stream, description: description, usage: 'stream <on/off/status>') do |event, option|
        parse_event(event, event.user.id, :stream, option)
      end

      command(:twitch, usage: 'twitch <username> <on/off/status>', required_permissions: [:administrator],
              help_available: false, permission_message: false) do |event, username, option|
        user = Twitch.user(username) if username

        if user
          parse_event(event, user[:_id], :twitch, option)
        else
          reply = event.message.reply("I couldn't find that Twitch user, plip!")
          delete_request(event.message, reply)
        end
      end

      private
      def self.parse_event(event, id, command, option)
        case(option)
        when 'on'
          Twitch.enable_stream(id, command)
          reply = event.message.reply('Stream updates enabled successfully, plip!')
          delete_request(event.message, reply)
        when 'off'
          Twitch.disable_stream(id, command)
          reply = event.message.reply('Stream updates disabled successfully, plip!')
          delete_request(event.message, reply)
        when 'status'
          status = Twitch.stream_status(id, command)
          reply = event.message.reply("Stream updates are currently **#{status}**, plip!")
          delete_request(event.message, reply)
        else
          reply = event.message.reply("Usage: `#{event.bot.commands[command].attributes[:usage]}`")
          delete_request(event.message, reply)
        end
      end
    end
  end
end
