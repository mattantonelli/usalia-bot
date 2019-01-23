require 'rubygems'
require 'bundler/setup'
require 'json'
require 'open-uri'
require 'ostruct'
require 'time'
require 'yaml'

Bundler.require(:default)

module UsaliaBot
  CONFIG = OpenStruct.new(YAML.load_file('config/config.yml'))

  Dir['lib/usalia_bot/*.rb'].each { |file| load file }

  mention_prefix = ["<@#{CONFIG.client_id}>", "<@!#{CONFIG.client_id}>"]
  bot = Discordrb::Commands::CommandBot.new(token: CONFIG.token, client_id: CONFIG.client_id,
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

  Scheduler.run(bot)

  logfile = File.open('log.txt', 'a')
  $stderr = logfile
  Discordrb::LOGGER.streams << logfile

  bot.run
end
