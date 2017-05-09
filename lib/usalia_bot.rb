require 'discordrb'
require 'yaml'

module UsaliaBot
  config = YAML.load_file('config/app.yml')
  TOKEN = config['token']
  CLIENT_ID = config['client_id']

  bot = Discordrb::Commands::CommandBot.new(token: TOKEN, client_id: CLIENT_ID)

  Dir['lib/usalia_bot/events/*.rb'].each { |file| load file }
  Events.constants.each do |event|
    bot.include!(Events.const_get(event))
  end

  bot.run
end
