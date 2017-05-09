module UsaliaBot
  module Events
    module TimeConverter
      extend Discordrb::EventContainer
      include HelperMethods

      TIME_REGEX = /convert (\d{1,2}:\d{1,2}(?:\s?[ap]m)?)\s([a-z]{3,}) to ([a-z]{3,})/i
      ZONE_CONVERSIONS = { est: 'America/New_York', edt: 'America/New_York',
                           cst: 'America/Chicago', cdt: 'America/Chicago',
                           mst: 'America/Denver', mdt: 'America/Denver',
                           pst: 'America/Los_Angeles', pdt: 'America/Los_Angeles',
                           aest: 'Australia/Melbourne', aedt: 'Australia/Melbourne',
                           bst: 'Europe/London' }

      message(start_with: /#{MENTION} convert/i) do |event|
        message = event.message
        match = message.content.match(TIME_REGEX)

        if match.nil?
          return message.reply("I can't understand your message, plip! " \
                               'Try something like this: `convert 8:00pm EST to GMT`')
        end

        time, zone, requested_zone = match.captures

        begin
          zone_identifier = ZONE_CONVERSIONS[zone.downcase.to_sym] || zone
          time_in_utc = TZInfo::Timezone.get(zone_identifier)
            .local_to_utc(Time.parse(time).to_i)

          requested_zone_identifier = ZONE_CONVERSIONS[requested_zone.downcase.to_sym] || requested_zone
          requested_zone_info = TZInfo::Timezone.get(requested_zone_identifier)
          requested_time = Time.at(requested_zone_info.utc_to_local(time_in_utc))
          requested_zone_abbreviation = requested_zone_info.strftime('%Z')

          result = requested_time.strftime("%l:%M%P #{requested_zone_abbreviation}")
          message.reply(result)
        rescue ArgumentError
          message.reply('The time you entered is invalid, plip! Try something like `8:00pm` or `20:00`')
        rescue TZInfo::InvalidTimezoneIdentifier
          message.reply('One of your timezones is invalid, plip! Try something like `EST` or `GMT`')
        end
      end
    end
  end
end
