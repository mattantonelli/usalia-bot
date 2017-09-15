module UsaliaBot
  module Commands
    module Stream
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods
      include UsaliaBot::Redis

      description = 'Broadcasts when you start streaming. Your Discord account must be connected to Twitch.'

      command(:stream, description: description, max_args: 1, usage: 'stream <on/off/status>') do |event, option|
        user_id = event.user.id

        case(option)
        when 'on'
          Redis.hset('stream-status', user_id, 'inactive')
          Redis.hset('stream-time', user_id, Time.at(0))
          reply = event.message.reply('Stream updates enabled successfully, plip!')
        when 'off'
          Redis.hdel('stream-status', user_id)
          Redis.hdel('stream-time', user_id)
          reply = event.message.reply('Stream updates disabled successfully, plip!')
        when 'status'
          status = Redis.hexists?('stream-status', user_id) ? 'enabled' : 'disabled'
          reply = event.message.reply("Stream updates for your user are currently **#{status}**, plip!")
        else
          reply = event.message.reply('Usage: `stream <on/off>`')
        end

        delete_request(event.message, reply)
      end
    end
  end
end
