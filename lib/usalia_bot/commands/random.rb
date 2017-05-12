module UsaliaBot
  module Commands
    module Random
      extend Discordrb::Commands::CommandContainer

      command(:random, description: 'Roll a random number from 1 to 999.', usage: 'random') do |event|
        user = event.message.author.name
        result = rand(1..999)
        "Random! #{user} rolls a #{result}."
      end
    end
  end
end
