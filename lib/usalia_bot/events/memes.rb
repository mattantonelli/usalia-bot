module UsaliaBot
  module Events
    module Memes
      extend Discordrb::EventContainer
      include HelperMethods

      # curry|:curry:
      message(content: /#{MENTION} such a lust for (?:curry|🍛)/i) do |event|
        event.message.reply('*Whooooooooo!?*')
      end
    end
  end
end
