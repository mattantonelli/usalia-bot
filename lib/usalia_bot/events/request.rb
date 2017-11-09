module UsaliaBot
  module Events
    module Request
      extend Discordrb::EventContainer
      extend UsaliaBot::HelperMethods

      # When a qualified user first adds the :bell: reaction to a message in the request channel
      reaction_add(emoji: '🔔') do |event|
        message = event.message
        next unless request?(event) && event.user.permission?(:mention_everyone) && message.my_reactions.empty?

        # Add the configured request reactions
        CONFIG.request_reactions.each do |reaction|
          message.react(reaction)
        end

        # Pin the message, announce it, and remove the original :bell: reaction
        message.pin
        message.reply("@everyone A new request has been created for #{event.message.author.mention}, plip! If you would like " \
                      'to help, please indicate your available roles and experience on the pinned message above.')
        message.delete_reaction(event.user, '🔔')
      end

      # When a qualified officer adds the :mega: reaction to a message in the request channel
      reaction_add(emoji: '📣') do |event|
        next unless request?(event) && event.user.permission?(:mention_everyone)

        message = event.message

        # Mention users who have reacted to the message, excluding the user who
        # added the :mega: reaction, and then remove the :mega: reaction
        reactions = message.reactions.reject { |k, v| k == '📣' }.values.map(&:to_s)
        mentions = reactions.flat_map { |reaction| message.reacted_with(reaction) }
          .reject(&:current_bot?).map(&:mention).uniq

        message.reply(mentions.join(' ')) unless mentions.empty?
        message.delete_reaction(event.user, '📣')
      end
    end
  end
end
