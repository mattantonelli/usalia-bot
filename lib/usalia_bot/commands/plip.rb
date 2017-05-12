module UsaliaBot
  module Commands
    module Plip
      extend Discordrb::Commands::CommandContainer

      command(:plip, description: 'Check if Usalia is awake.', usage: 'plip') do |event|
        'Plip!'
      end

      # :curry:
      command(:🍛, description: 'Give Usalia some curry!', usage: ':curry:') do |event|
        'P-plip! :heart_eyes:'
      end
    end
  end
end
