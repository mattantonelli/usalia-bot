module UsaliaBot
  module Commands
    module Reminder
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      command(:remindme, description: 'Set a reminder for yourself', usage: 'reminder <time> <message>') do |event, time, *message|
        set_reminder(event, time, "#{event.author.mention} #{message.join(' ')}")
      end

      command(:reminder, description: 'Set a reminder', usage: 'reminder <time> <message>') do |event, time, *message|
        set_reminder(event, time, message.join(' '))
      end

      def self.set_reminder(event, time, message)
        if time.nil?
          return 'You forgot to provide a time, plip!'
        elsif message.empty?
          return 'You forgot to provide a message, plip!'
        end

        unit = time.scan(/\w$/).first
        duration = time.to_i

        case(unit)
        when 'm'
          duration *= 60
        when 'h'
          duration *= 3600
        when 'd'
          duration *= 86400
        else
          return 'Your time is invalid, plip! Try something like 5m or 3h.'
        end

        reminder_time = (round_to_minute(Time.now) + duration).to_i
        reminder = { channel: event.channel.id, message: message }

        if reminders = Redis.hget(:reminders, reminder_time)
          Redis.hset(:reminders, reminder_time, (JSON.parse(reminders) << reminder).to_json)
        else
          Redis.hset(:reminders, reminder_time, [reminder].to_json)
        end

        "Okay. I'll remind you, plip!"
      end
    end
  end
end
