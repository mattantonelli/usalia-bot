module UsaliaBot
  module Commands
    module ReadyCheck
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:ready, description: 'Initiates a ready check for the mentioned users/roles.',
              usage: 'ready <@user|role> <@user|role> ...') do |event|
        break if event.channel.pm?

        author = event.author
        message = event.message

        # Mentions include any users mentioned in the message (except for the bot),
        # any members in mentioned roles,
        # and the user who initiated the ready check
        mentions = message.mentions.reject(&:current_bot?).map(&:id)
        mentions += role_mention_members(message, true).map(&:id)
        mentions << author.id
        mentions.uniq!

        if mentions.size == 1
          return message.reply('You need to mention at least one other user, plip!')
        end

        check = message.reply("#{author.display_name} has initiated a ready check. " \
                              'Please confirm your status below.')
        check.react('✅') # :white_check_mark:
        check.react('❌') # :x:

        sleep(30)

        # Mentioned users who have reacted with :white_check_mark: are considered ready
        # The user who initiated the ready check is considered ready by default
        ready_users = mentions & event.channel.message(check.id).reacted_with('✅').push(author).map(&:id)

        # All remaining mentioned users are considered not ready
        not_ready_users = mentions - ready_users

        response = "Ready check complete.\n\n" \
          "**Ready:** #{ready_users.size}/#{mentions.size}\n" \
          "**Not Ready:** #{not_ready_users.size}/#{mentions.size}"

        if not_ready_users.size > 0
          names = not_ready_users.map { |user| event.server.member(user).display_name }
          response += " (#{names.join(', ')})"
        end

        response
      end
    end
  end
end
