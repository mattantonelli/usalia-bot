module UsaliaBot
  module Events
    module Maintenance
      extend Discordrb::EventContainer

      message(from: CONFIG.lodestone_news_user_id) do |event|
        embed = event.message.embeds.first

        if embed.title.match?('All Worlds Maintenance')
          response = Nokogiri::HTML(open(embed.url))
          text = response.at_css('.news__detail__wrapper').text.scan(/\[Date & Time\]\n.*?\n/).first
          time_zone = text.match(/\((\w+)\)/)[1]
          start_time, end_time = text.scan(/[a-z]{3}\. \d{1,2}, \d{4} \d{1,2}:\d{2} [ap]\.m\./i)
            .map { |time| Time.parse("#{time} #{time_zone}").utc }

          Redis.hset(:maintenance, :start, start_time)
          Redis.hset(:maintenance, :end, end_time)
          Redis.hset(:maintenance, :url, embed.url)
        end
      end
    end
  end
end
