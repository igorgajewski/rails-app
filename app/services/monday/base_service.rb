require "faraday"

module Monday
  class BaseService
    BASE_URL = "https://api.monday.com/v2"

    def initialize
      @token = ENV["MONDAY_API_TOKEN"]
    end

    def post(query:, variables: {})
      response = Faraday.post(BASE_URL) do |req|
        req.headers["Authorization"] = @token
        req.headers["Content-Type"] = "application/json"
        req.body = { query: query, variables: variables }.to_json
      end

      JSON.parse(response.body)
    end
  end
end
