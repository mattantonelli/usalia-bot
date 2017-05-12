require 'discordrb'
require 'dotenv/load'
require 'tzinfo'
require 'yaml'

module UsaliaBot
  TOKEN, CLIENT_ID = ENV.values_at('TOKEN', 'CLIENT_ID')

  bot = Discordrb::Commands::CommandBot.new(token: TOKEN, client_id: CLIENT_ID)

  require_relative 'usalia_bot/helper_methods'

  Dir['lib/usalia_bot/events/*.rb'].each { |file| load file }
  Events.constants.each do |event|
    bot.include!(Events.const_get(event))
  end

  bot.run
end
