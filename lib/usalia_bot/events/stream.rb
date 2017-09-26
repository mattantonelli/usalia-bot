module UsaliaBot
  module Events
    module Stream
      extend Discordrb::EventContainer
      extend UsaliaBot::HelperMethods
      include UsaliaBot::Redis
      include UsaliaBot::Twitch

      playing do |event|
        # User must first enable stream updates with the "stream on" command
        if Redis.hexists?('stream-status', event.user.id)
          Twitch.stream_event(event)
        end
      end
    end
  end
end
