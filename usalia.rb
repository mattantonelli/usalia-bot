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
    emojis.each { |emoji| message.react(emoji) }
  end
end

bot.message_edit(start_with: /\/poll/i) do |event|
  message = event.channel.message(event.message.id)
  emojis = message.content.scan(EMOJI_REGEX).flatten.compact
  bot_reactions = message.reactions.values.select(&:me)
    .map { |reaction| [reaction.name, reaction.id].compact.join(':') }

  new_emojis = emojis - bot_reactions
  new_emojis.each do |emoji|
    message.react(emoji)
  end

  old_emojis = bot_reactions - emojis
  old_emojis.each do |emoji|
    message.delete_own_reaction(emoji)
  end
end

bot.run
