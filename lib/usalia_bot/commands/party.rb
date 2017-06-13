module UsaliaBot
  module Commands
    module Party
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods
      include UsaliaBot::Redis

      command(:party, description: 'Create a temporary voice channel for a party', usage: 'party') do |event|
        break if event.channel.pm?

        channels = JSON.parse(Redis.get_json('temp-channels'))
        user_id = event.user.id.to_s

        if channels.size > 4
          return event.message.reply('Sorry. There can only be five party channels active at the same time, plip!')
        end

        if channels[user_id].nil?
          channel_name = "#{event.author.display_name}'s Party".sub("s's", "s'")
          channel = event.server.create_channel(channel_name, 2)
          channels[user_id] = { channel_id: channel.id, created_at: Time.now }
          Redis.set('temp-channels', channels.to_json)

          "A new party channel has been created for #{event.author.mention}, plip!"
        else
          'You already have your own party channel, plip!'
        end
      end
    end
  end
end
