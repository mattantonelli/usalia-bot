module UsaliaBot
  module Commands
    module Purge
      extend Discordrb::Commands::CommandContainer

      command(:purge, help_available: false, required_permissions: [:manage_messages],
              permission_message: false) do |event, number|
        purge_amount = number.to_i + 1

        if purge_amount.between?(2, 100)
          event.channel.prune(purge_amount)
        else
          event.message.reply('Please give me a number between 1 and 99, plip! (e.g. purge 10)')
        end
      end
    end
  end
end
