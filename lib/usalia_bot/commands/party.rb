module UsaliaBot
  module Commands
    module Party
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:party, description: 'Creates a temporary voice channel for a party. ' \
              'Creates a private channel if other users are tagged.',
              usage: 'party (<@user> <@user> ...)') do |event|
        break if event.channel.pm?

        channels = get_channels
        user_id = event.user.id.to_s
        message = event.message

        if channels.size > 4
          reply = message.reply('Sorry. There can only be five party channels active at the same time, plip!')
        elsif !channels[user_id].nil?
          reply = message.reply('You already have your own party channel, plip!')
        else
          create_channel(event, channels, user_id)
          reply = message.reply("A new party channel has been created, plip!")
        end

        delete_request(message, reply)
      end

      command(:disband, description: 'Disbands your party', usage: 'disband') do |event|
        break if event.channel.pm?

        message = event.message

        if disband_party(event.bot, event.user.id.to_s)
          reply = message.reply('Your party has been disbanded, plip!')
        else
          reply = message.reply("You don't have a party to disband, plip!")
        end

        delete_request(message, reply)
      end

      def self.create_channel(event, channels, user_id)
        server = event.server
        mentions = message_mentions(event.message, include_bot: true)

        name = "#{event.author.display_name}'s Party".sub("s's", "s'")
        category = server.categories.sort_by(&:position).last
        channel = server.create_channel(name, 2, parent: category)
        channels[user_id] = { server_id: server.id, channel_id: channel.id, created_at: Time.now }

        # If members are mentioned in the request, make the channel private using a role
        if mentions.size > 2
          role = create_role(server, channel, mentions)
          channels[user_id][:role_id] = role.id
        end

        set_channels(channels)
        channel
      end

      def self.create_role(server, channel, members)
        role = server.create_role(name: channel.name, permissions: 0)
        role.name = channel.name

        members.each { |member| member.add_role(role)}

        permissions = Discordrb::Permissions.new
        permissions.can_connect = true

        # Allow user with the role to connect to the channel
        channel.define_overwrite(role, permissions, nil)

        # Disallow everyone else to connect to the channel
        channel.define_overwrite(server.everyone_role, nil, permissions)

        role
      end

      def self.disband_party(bot, user_id)
        channels = get_channels
        details = channels[user_id]

        if details
          channel = bot.channel(details['channel_id'])
          server = bot.server(details['server_id'])
          role = server.role(details['role_id']) if details['role_id']

          channel.delete if channel
          role.delete if role
          channels.delete(user_id)

          set_channels(channels)
          channel
        end
      end

      def self.get_channels
        JSON.parse(Redis.get_json('temp-channels'))
      end

      def self.set_channels(channels)
        Redis.set('temp-channels', channels.to_json)
      end
    end
  end
end
