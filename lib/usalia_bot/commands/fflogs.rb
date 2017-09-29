module UsaliaBot
  module Commands
    module FFLogs
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:fflogs, help_available: false, required_permissions: [:administrator],
              permission_message: false) do |event, owner, option|
        case(option)
        when 'on'
          Redis.hset('fflogs-channels', owner.downcase, event.channel.id)
          reply = event.message.reply("FF Logs updates for **#{owner}** will be posted in this channel.")
        when 'off'
          Redis.hdel('fflogs-channels', owner.downcase)
          reply = event.message.reply("FF Logs updates will no longer be posted for **#{owner}**.")
        when 'status'
          if channel_id = Redis.hget('fflogs-channels', owner.downcase)
            channel = event.bot.channel(channel_id, event.server)
            reply = event.message.reply("FF Logs updates for **#{owner}** are posted in <##{channel.id}>.")
          else
            reply = event.message.reply("FF Logs updates are not currently posted for **#{owner}**.")
          end
        else
          reply = event.message.reply("Usage: `fflogs <owner> <on/off/status>`")
        end

        delete_request(event.message, reply)
      end
    end
  end
end
