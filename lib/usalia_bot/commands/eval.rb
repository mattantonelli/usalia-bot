module UsaliaBot
  module Commands
    module Eval
      extend Discordrb::Commands::CommandContainer

      command(:eval, help_available: false) do |event, *code|
        break unless event.user.id == CONFIG.owner_id

        begin
          eval code.join(' ')
        rescue => e
          "```#{e}```"
        end
      end
    end
  end
end
