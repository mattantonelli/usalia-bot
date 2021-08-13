module UsaliaBot
  module Commands
    module TimeConverter
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      TIME_REGEX = /convert (\d{1,2}(?::\d{1,2})?(?:\s?[ap]m)?)\s([a-z]{2,}) to ([a-z]{2,})/i
      ZONE_CONVERSIONS = { et: 'America/New_York', est: 'America/New_York', edt: 'America/New_York',
                           ct: 'America/Chicago', cst: 'America/Chicago', cdt: 'America/Chicago',
                           mt: 'America/Denver', mst: 'America/Denver', mdt: 'America/Denver',
                           pt: 'America/Los_Angeles', pst: 'America/Los_Angeles', pdt: 'America/Los_Angeles',
                           aet: 'Australia/Melbourne', aest: 'Australia/Melbourne', aedt: 'Australia/Melbourne',
                           bst: 'Europe/London' }

      command(:convert, description: 'Convert time from one zone to another.',
                        usage: 'convert <time> <zone> to <new_zone>') do |event|
        message = event.message
        match = message.content.match(TIME_REGEX)

        if match.nil?
          reply = message.reply("I can't understand your message, plip! " \
                                'Try something like this: `convert 8pm EST to GMT`')
          return delete_request(message, reply)
        end

        time, zone, requested_zone = match.captures

        begin
          zone_identifier = ZONE_CONVERSIONS[zone.downcase.to_sym] || zone.upcase
          time_in_utc = TZInfo::Timezone.get(zone_identifier)
            .local_to_utc(Time.parse(time))

          requested_zone_identifier = ZONE_CONVERSIONS[requested_zone.downcase.to_sym] || requested_zone.upcase
          requested_zone_info = TZInfo::Timezone.get(requested_zone_identifier)
          requested_time = Time.at(requested_zone_info.utc_to_local(time_in_utc))
          requested_zone_abbreviation = requested_zone_info.strftime('%Z')

          result = requested_time.strftime("%l:%M%P #{requested_zone_abbreviation}")
          result
        rescue ArgumentError
          reply = event.message.reply('The time you entered is invalid, plip! Try something like `8pm`, `8:00pm`, or `20:00`')
          delete_request(event.message, reply)
        rescue TZInfo::InvalidTimezoneIdentifier
          reply = event.message.reply('One of your timezones is invalid, plip! Try something like `EST` or `GMT`')
          delete_request(event.message, reply)
        end
      end
    end
  end
end
