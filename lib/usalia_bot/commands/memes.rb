module UsaliaBot
  module Commands
    module Memes
      extend Discordrb::Commands::CommandContainer

      command(:spongebob, description: 'Repeats the given text (or previous message if none given) as a Spongebob meme.',
              usage: 'spongebob (<text>)') do |event, *text|
        if text.size > 0
          message = text.join(' ')
        else
          message = event.channel.history(1, event.message.id).first&.content
        end

        message.chars.map { |c| rand(2) == 1 ? c.upcase : c.downcase }.join if message
      end
    end
  end
end
