module UsaliaBot
  module Commands
    module Pin
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:pin, help_available: false, required_permissions: [:move_members],
              permission_message: false) do |event, message_id|
        pin_message(event, message_id)
      end

      command(:unpin, help_available: false, required_permissions: [:move_members],
              permission_message: false) do |event, message_id|
        pin_message(event, message_id, false)
      end

      private
      def self.pin_message(event, message_id, pin = true)
        begin
          message = event.channel.message(message_id)
          throw ArgumentError unless message

          if pin
            if message.pinned?
              reply = event.message.reply('That message is already pinned, plip!')
            else
              message.pin
            end
          else
            if message.pinned?
              message.unpin
              reply = event.message.reply('The message has been unpinned, plip!')
            else
              reply = event.message.reply("That message isn't pinned, plip!")
            end

            delete_request(event.message, reply)
          end
        rescue RestClient::BadRequest, ArgumentError
          reply = event.message.reply("I couldn't find that message ID in this channel, plip!") unless message
          delete_request(event.message, reply)
        end

      end
    end
  end
end
