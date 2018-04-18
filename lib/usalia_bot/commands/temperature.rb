module UsaliaBot
  module Commands
    module Temperature
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      TEMPERATURE_REGEX = /temp (\-?\d+) ?°? ?([CF])/i

      command(:temp, description: 'Converts between Celsius and Fahrenheit.',
              usage: 'temp <value> <C/F>') do |event|
        message = event.message
        match = message.content.match(TEMPERATURE_REGEX)

        if match.nil?
          reply = message.reply("I can't understand your message, plip! " \
                                'Try something like this: `temp 70F`')
          return delete_request(message, reply)
        end

        temp, unit = match.captures
        if unit.casecmp?('c')
          # Convert from Celsius to Fahrenheit
          "#{(temp.to_f * (9 / 5.0) + 32).round}°F"
        else
          # Convert from Fahrenheit to Celsius
          "#{((temp.to_f - 32) * (5 / 9.0)).round}°C"
        end
      end
    end
  end
end
