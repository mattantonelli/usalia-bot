module UsaliaBot
  module Commands
    module FFLogs
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:poll, description: 'Adds reactions to the message to create a poll.',
              usage: 'poll <question/emojis>') do |event|
        message = event.message
        emojis = message.content.scan(emoji_regex).flatten.compact

        if emojis.empty?
          message.react('👍') # :thumbsup:
          message.react('👎') # :thumbsdown:
        else
          emojis.each { |emoji| message.react(emoji) }
        end

        nil
      end
    end
  end
end
