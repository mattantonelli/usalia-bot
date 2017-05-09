module UsaliaBot
  module Events
    module Plip
      extend Discordrb::EventContainer
      include HelperMethods

      message(start_with: /#{MENTION} plip/i) do |event|
        event.message.reply('Plip!')
      end
    end
  end
end
