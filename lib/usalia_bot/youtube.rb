module UsaliaBot
  module Youtube
    extend self

    YOUTUBE_API_URL = 'https://www.googleapis.com/youtube/v3'.freeze
    YOUTUBE_API_SEARCH_URL = "#{YOUTUBE_API_URL}/search" \
      "?type=video&maxResults=1&part=snippet&key=#{CONFIG.youtube_api_key}".freeze
    YOUTUBE_VIDEO_URL = 'https://www.youtube.com/watch'.freeze

    def search(query)
      response = RestClient.get("#{YOUTUBE_API_SEARCH_URL}&q=#{query}")
      data = JSON.parse(response.body, symbolize_names: true)
      video_id = data[:items].first[:id][:videoId]
      "#{YOUTUBE_VIDEO_URL}?v=#{video_id}"
    end
  end
end
