require 'discordrb'
require 'dotenv/load'
require 'tzinfo'
require 'yaml'

module UsaliaBot
  TOKEN, CLIENT_ID = ENV.values_at('TOKEN', 'CLIENT_ID')
  OWNER_ID, OFFICER_ROLE = ENV.values_at('OWNER_ID', 'OFFICER_ROLE_ID').map(&:to_i)
  REQUEST_CHANNELS, REQUEST_REACTIONS =
    ENV.values_at('REQUEST_CHANNEL_IDS', 'REQUEST_REACTIONS').map { |val| JSON.parse(val) }

  require_relative 'usalia_bot/helper_methods'

  mention_prefix = ["<@#{CLIENT_ID}>", "<@!#{CLIENT_ID}>"]
  bot = Discordrb::Commands::CommandBot.new(token: TOKEN, client_id: CLIENT_ID,
                                            prefix: mention_prefix, spaces_allowed: true,
                                            help_command: false, log_mode: :quiet)

  Dir['lib/usalia_bot/commands/*.rb'].each { |file| load file }
  Commands.constants.each do |event|
    bot.include!(Commands.const_get(event))
  end

  Dir['lib/usalia_bot/events/*.rb'].each { |file| load file }
  Events.constants.each do |event|
    bot.include!(Events.const_get(event))
  end

  COMMANDS = bot.commands

  bot.run
end
