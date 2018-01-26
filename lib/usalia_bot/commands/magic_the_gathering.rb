module UsaliaBot
  module Commands
    module MagicTheGathering
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      MTG_API_URL = 'https://api.magicthegathering.io/v1'.freeze

      command(:mtg, description: "Looks up a Magic: The Gathering card by name", usage: 'mtg <card name>') do |event, *name|
        card_name = name.join(' ').downcase

        begin
          response = RestClient.get("#{MTG_API_URL}/cards/?name=\"#{card_name}\"&contains=imageUrl&pageSize=1")
          body = JSON.parse(response.body, symbolize_names: true)

          if card = body[:cards].first
            embed_card_data(event, card)
          else
            error = event.message.reply("I couldn't find that card, plip!")
          end
        rescue
          error = event.message.reply('Sorry. There was a problem retrieving the card data, plip!')
        end

        delete_request(event.message, error, 10) if error
      end

      private
      def self.embed_card_data(event, card)
        if card[:type] =~ /Basic Land/
          return event.channel.send_embed do |embed|
            embed.image = Discordrb::Webhooks::EmbedImage.new(url: card[:imageUrl])
          end
        end

        event.channel.send_embed do |embed|
          embed.colour = card_color(card)
          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: card[:name], url: card[:imageUrl])
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: card[:imageUrl])

          stats = { Cost: card[:manaCost]&.delete('{}'), Type: card[:type], Loyalty: card[:loyalty].to_s,
                    "P/T": card.values_at(:power, :toughness).compact.join('/') }
          stats_field = stats.map { |k, v| "**#{k}:** #{v}" if v && !v.empty? }.compact.join("\n")
          embed.add_field(name: "\u200b", value: stats_field) unless stats_field.empty?

          text_field = format_text(card[:text]) || ''
          text_field << "\n\n*#{format_text(card[:flavor])}*" if card[:flavor]
          embed.add_field(name: "\u200b", value: text_field) unless text_field.empty?
        end
      end

      def self.card_color(card)
        return nil unless cost = card[:manaCost]

        if cost.scan(/[WUBRG]/).uniq.count > 1
          0xC5AF67
        else
          case cost
          when /W/
            0xF5F2DC
          when /U/
            0xAAE0FA
          when /B/
            0x231F20
          when /R/
            0xA63426
          when /G/
            0x3A7359
          when /\d+/
            0x9FAEB9
          end
        end
      end

      def self.format_text(text)
        text&.delete('{}')&.gsub('T:', 'Tap:')&.gsub("\n", "\n\n")
      end
    end
  end
end
