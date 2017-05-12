module UsaliaBot
  module Events
    module Poll
      extend Discordrb::EventContainer

      emoji_list = File.read('data/emoji_list.txt').chomp
      EMOJI_REGEX = /(#{emoji_list})|(?:<:(\w+:\d+)>)/

      message(start_with: /\/poll/i) do |event|
        message = event.message
        emojis = message.content.scan(EMOJI_REGEX).flatten.compact

        if emojis.empty?
          message.react('👍') # :thumbsup:
          message.react('👎') # :thumbsdown:
        else
          emojis.each { |emoji| message.react(emoji) }
        end
      end

      message_edit(start_with: /\/poll/i) do |event|
        message = event.channel.message(event.message.id)
        emojis = message.content.scan(EMOJI_REGEX).flatten.compact
        bot_reactions = message.reactions.values.select(&:me)
          .map { |reaction| [reaction.name, reaction.id].compact.join(':') }

        # Add reactions that are in the message and not in the reactions
        new_emojis = emojis - bot_reactions
        new_emojis.each do |emoji|
          message.react(emoji)
        end

        # Remove reactions that are no longer present in the message, except
        # for thumbsup and thumbsdown which may have been added by default
        old_emojis = bot_reactions - emojis - ['👍', '👎']
        old_emojis.each do |emoji|
          message.delete_own_reaction(emoji)
        end
      end
    end
  end
end
