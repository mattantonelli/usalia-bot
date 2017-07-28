module UsaliaBot
  module Commands
    module Purge
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:purge, help_available: false, required_permissions: [:manage_messages],
              permission_message: false) do |event, number|
        purge_amount = number.to_i + 1

        if purge_amount.between?(2, 100)
          begin
            event.channel.prune(purge_amount, true)
          rescue ArgumentError
            reply = event.message.reply('You cannot purge messages older than 2 weeks, plip!')
          end
        else
          reply = event.message.reply('Please give me a number between 1 and 99, plip! (e.g. purge 10)')
        end

        delete_request(event.message, reply, 10) if reply
      end
    end
  end
end
