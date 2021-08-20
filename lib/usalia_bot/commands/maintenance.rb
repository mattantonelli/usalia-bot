module UsaliaBot
  module Commands
    module Maintenance
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      MAINTENANCE_URL = 'http://na.lodestonenews.com/news/maintenance/current'.freeze
      TIME_FORMAT = '%a %-d %b %-I:%M %p'.freeze
      TIME_ZONES = [ { name: 'America/Los_Angeles', emoji: 'flag_us' }, { name: 'America/New_York', emoji: 'flag_us' },
                     { name: 'GMT', emoji: 'flag_gb' }, { name: 'Japan', emoji: 'flag_jp' },
                     { name: 'Australia/Melbourne', emoji: 'flag_au' } ].freeze

      command(:maintenance, description: 'Details on an upcoming FFXIV maintenance window.', usage: 'maintenance') do |event|
        begin
          maintenance = JSON.parse(RestClient.get(MAINTENANCE_URL))['game']

          if maintenance['title']&.match?('All Worlds Maintenance')
            start_time = Time.parse(maintenance['start'])
            end_time = Time.parse(maintenance['end'])

            if Time.now > start_time
              difference = end_time - Time.now
              relative_time = "Maintenance is currently underway.\nIt is expected to last for another " \
                "#{(difference / 3600).to_i} hours and #{(difference % 3600 / 60).to_i} minutes."
            else
              to_start = start_time - Time.now
              duration = end_time - start_time
              relative_time = "Maintenance begins in " \
                "#{(to_start / 3600).to_i} hours and #{(to_start % 3600 / 60).to_i} minutes.\n" \
                "It is expected to last for #{(duration / 3600).to_i} hours and #{(duration % 3600 / 60).to_i} minutes."
            end

            times = TIME_ZONES.map do |zone|
              format_maintenance_time(start_time, end_time, zone[:name], zone[:emoji])
            end

            event.channel.send_embed do |embed|
              embed.title = 'View on Lodestone'
              embed.url = maintenance['url']
              embed.color = 13413161
              embed.author = Discordrb::Webhooks::EmbedAuthor
                .new(name: 'All Worlds Maintenance', icon_url: 'http://na.lodestone.raelys.com/images/maintenance.png')
              embed.description = "#{times.join("\n")}\n\n#{relative_time}"
            end
          else
            event.message.reply('There is currently no planned maintenance, plip!')
          end
        rescue
          event.message.reply('Sorry. There was a problem retrieving the maintenance info, plip!')
        end
      end

      private
      def self.format_maintenance_time(start_time, end_time, time_zone, emoji)
        zone_info = TZInfo::Timezone.get(time_zone)
        zone_abbreviation = zone_info.strftime('%Z')
        ":#{emoji}: #{zone_info.utc_to_local(start_time).strftime(TIME_FORMAT)} to " \
          "#{zone_info.utc_to_local(end_time).strftime(TIME_FORMAT)} (#{zone_abbreviation})"
      end
    end
  end
end
