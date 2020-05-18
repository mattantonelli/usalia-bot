module UsaliaBot
  module FFXIVWorldStatus
    extend self

    FFXIV_WORLD_STATUS_URL = 'https://na.finalfantasyxiv.com/lodestone/worldstatus/'.freeze
    FFXIV_WORLD_STATUS_KEY = 'ffxiv-world-status'.freeze
    FFXIV_WORLD_STATUS_ICONS = { 'available'   => 'https://i.imgur.com/LKup4I0.png',
                                 'unavailable' => 'https://i.imgur.com/JCjWn4s.png' }.freeze

    def fetch(bot, report = true)
      page = Nokogiri::HTML(open(FFXIV_WORLD_STATUS_URL))
      all_worlds = page.css('.world-list__item')
      worlds_by_region = { japan: all_worlds[0..31],
                           north_america: all_worlds[32..55],
                           europe: all_worlds[56..-1] }

      worlds_by_region.each do |region, worlds|
        channel = bot.channel(CONFIG.ffxiv_world_status[region.to_s])
        next if channel.nil?

        worlds.each do |world|
          name = world.at_css('.world-list__world_name').text.strip
          cached_status = Redis.hget(FFXIV_WORLD_STATUS_KEY, name.downcase)

          if world.css('i').last.attributes['data-tooltip'].text.match?('Available')
            current_status = '1'
          else
            current_status = '0'
          end

          if report && !cached_status.nil? && cached_status != current_status
            if current_status == '1'
              status = 'available'
              color = 8047698
            else
              status = 'unavailable'
              color = 14251895
            end

            channel.send_embed do |embed|
              embed.colour = color
              embed.description = "Character creation is now **#{status}.**"
              embed.timestamp = Time.now
              embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: name, url: FFXIV_WORLD_STATUS_URL)
              embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: FFXIV_WORLD_STATUS_ICONS[status])
            end
          end

          Redis.hset(FFXIV_WORLD_STATUS_KEY, name.downcase, current_status)
        end
      end
    end
  end
end
