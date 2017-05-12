module UsaliaBot
  module Events
    module Ready
      extend Discordrb::EventContainer

      ready do |event|
        event.bot.game = 'Disgaea 5'
      end
    end
  end
end
