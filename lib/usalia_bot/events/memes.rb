module UsaliaBot
  module Events
    module Memes
      extend Discordrb::EventContainer
      extend UsaliaBot::HelperMethods

      # curry|:curry:
      message(content: /#{bot_mention} such a lust for (?:curry|🍛)/i) do |event|
        event.message.reply('*Whooooooooo!?*')
      end
    end
  end
end
