module UsaliaBot
  module Commands
    module Skeleton
      extend Discordrb::Commands::CommandContainer
      extend UsaliaBot::HelperMethods

      GIPHY_API_URL = 'https://api.giphy.com/v1'.freeze

      command(:skeleton, description: 'Posts a random skeleton GIF by jjjjjohn', usage: 'skeleton') do |event|
        url = "#{GIPHY_API_URL}/gifs/search?api_key=#{CONFIG.giphy_api_key}" \
          "&q=@jjjjjohn+skeleton&limit=1&offset=#{rand(100)}"
        response = RestClient.get(url)
        JSON.parse(response.body, symbolize_names: true)[:data][0][:images][:original][:url]
      end
    end
  end
end
