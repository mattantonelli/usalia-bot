#!/usr/bin/env ruby

require 'discordrb'
require 'yaml'

CONFIG = YAML.load_file('config/app.yml')
EMOJI_LIST = File.read('data/emoji_list.txt').chomp
EMOJI_REGEX = /(#{EMOJI_LIST})|(?:<:(\w+:\d+)>)/

bot = Discordrb::Bot.new(token: CONFIG['token'], client_id: CONFIG['client_id'])

bot.message(start_with: /\/poll/i) do |event|
  message = event.message
  emojis = message.content.scan(EMOJI_REGEX).flatten.compact

  if emojis.empty?
    message.react('👍')
    message.react('👎')
  else
    emojis.each do |emoji|
      message.react(emoji)
    end
  end
end

bot.run
