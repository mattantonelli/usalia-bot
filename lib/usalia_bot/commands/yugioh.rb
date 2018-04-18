module UsaliaBot
  module Commands
    module Yugioh
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      YUGIOH_API_URL = 'http://yugiohprices.com/api'.freeze

      command(:yugioh, description: "Looks up a Yu-Gi-Oh! card by name", usage: 'yugioh <card name>') do |event, *name|
        card_name = name.join('+').downcase

        begin
          response = RestClient.get("#{YUGIOH_API_URL}/card_data/#{card_name}")
          body = JSON.parse(response.body, symbolize_names: true)

          if body[:status] == 'success'
            embed_card_data(event, body[:data], card_name)
          else
            error = event.message.reply("I couldn't find that card, plip!")
          end
        rescue
          error = event.message.reply('Sorry. There was a problem retrieving the card data, plip!')
        end

        delete_request(event.message, error) if error
      end

      private
      def self.embed_card_data(event, data, card_name)
        event.channel.send_embed do |embed|
          embed.colour = card_color(data)

          image_url = "#{YUGIOH_API_URL}/card_image/#{card_name}"

          embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: data[:name], url: image_url)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: image_url)

          if data[:card_type] == 'monster'
            level, family, type, attack, defense = data.values_at(:level, :family, :type, :atk, :def)

            info = "**Level:** #{level}\n**Family:** #{capitalize(family)}\n**Type:** #{type}"
            stats = "**ATK:** #{attack}\n**DEF:**  #{defense}"

            embed.add_field(name: "\u200b", value: info, inline: true)
            embed.add_field(name: "\u200b", value: stats, inline: true)
            embed.add_field(name: "\u200b", value: data[:text])
          else
            type, property = data.values_at(:card_type, :property)

            embed.description = "\u200b"
            embed.add_field(name: "#{property} #{capitalize(type)}", value: data[:text])
          end
        end
      end

      def self.card_color(data)
        if data[:type]
          case data[:type]
          when /Normal/
            0x937A51
          when /Effect/
            0xC5653F
          when /Ritual/
            0x496AAF
          when /Fusion/
            0x5B228D
          end
        elsif data[:card_type] == 'spell'
          0x037374
        elsif data[:card_type] == 'trap'
          0xA3277F
        else
          0x937A51
        end
      end
    end
  end
end
