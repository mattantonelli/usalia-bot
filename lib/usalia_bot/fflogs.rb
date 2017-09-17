module UsaliaBot
  module FFLogs
    extend self

    FFLOGS_API_URL = "https://www.fflogs.com/v1/reports/guild/#{CONFIG.fflogs_guild}?api_key=#{CONFIG.fflogs_api_key}".freeze
    FFLOGS_REPORT_URL = 'https://www.fflogs.com/reports'.freeze
    FFLOGS_THUMBNAIL = 'https://www.fflogs.com/img/common/ff-logo.png'.freeze

    def poll(bot)
      reports = new_reports
      return if reports.empty?

      server = bot.servers.values.first
      channels = Redis.hgetall('fflogs-channels')

      reports.each do |report|
        owner = report[:owner]
        channel = bot.channel(channels[owner], server)
        send_embed(owner, channel, report)
        Redis.hset('fflogs-reports', report[:id], '')
      end
    end

    private
    def new_reports
      time = ((Time.now.to_f - 86400) * 1000).to_i
      response = RestClient.get("#{FFLOGS_API_URL}&start=#{time}")
      reports = JSON.parse(response.body, symbolize_names: true).sort_by { |report| report[:start] }
      reports.reject do |report|
        !Redis.hexists?('fflogs-channels', report[:owner].downcase) || Redis.hexists?('fflogs-reports', report[:id])
      end
    end

    def send_embed(owner, channel, report)
      url = "#{FFLOGS_REPORT_URL}/#{report[:id]}"

      channel.send_embed do |embed|
        embed.colour = 0x218aa6
        embed.description = "New report from **#{owner}**:\n#{url}"
        embed.timestamp = Time.at(report[:start] / 1000)

        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: FFLOGS_THUMBNAIL)
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: report[:title])
      end
    end
  end
end
