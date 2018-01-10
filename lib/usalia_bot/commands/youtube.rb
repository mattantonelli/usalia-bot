module UsaliaBot
  module Commands
    module Youtube
      extend Discordrb::Commands::CommandContainer

      command(:youtube, description: 'Search YouTube for videos.', usage: 'youtube <query>') do |event, *query|
        search(query)
      end

      # Alias to account for autocorrect
      command(:YouTube, help_available: false) do |event, *query|
        search(query)
      end

      private
      def self.search(*query)
        UsaliaBot::Youtube.search(query.join(' '))
      end
    end
  end
end
