module UsaliaBot
  module Commands
    module Purge
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      # Purge the given number of messages
      command(:purge, help_available: false, required_permissions: [:manage_messages],
              permission_message: false) do |event, number|
        amount = number.to_i + 1

        if amount.between?(2, 100)
          begin
            event.channel.prune(amount, true)
          rescue ArgumentError
            reply = event.message.reply('You cannot purge messages older than 2 weeks, plip!')
          end
        else
          reply = event.message.reply('Please give me a number between 1 and 99, plip! (e.g. purge 10)')
        end

        delete_request(event.message, reply) if reply
      end

      # Purge all messages up to and including the given message ID (max 100)
      command(:purgeto, help_available: false, required_permissions: [:manage_messages],
              permission_message: false) do |event, message_id|
        begin
          messages = event.channel.history(99, nil, message_id)
          event.channel.prune(messages.count + 1, true)
        rescue ArgumentError
          reply = event.message.reply('You cannot purge messages older than 2 weeks, plip!')
        rescue RestClient::BadRequest
          reply = event.message.reply('Please give me a valid message ID, plip! (e.g. purge 0123456789)')
        end

        delete_request(event.message, reply) if reply
      end
    end
  end
end
