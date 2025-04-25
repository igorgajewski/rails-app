class MondayService
    include HTTParty
    base_uri "https://api.monday.com/v2"

    def self.create_board(name, board_type)
      api_token = ENV["MONDAY_API_TOKEN"]
      headers = { "Authorization" => api_token, "Content-Type" => "application/json" }

      query = {
        query: "
          mutation {
            create_board (board_name: \"#{name}\", board_kind: #{board_type == 'public' ? 'public' : 'private'}) {
              id
              name
            }
          }
        "
      }

      response = post("", body: query.to_json, headers: headers)

    # Check if the response is successful by inspecting the status code or the response content
    if response.code == 200 && response.parsed_response["data"]
        response.parsed_response["data"]["create_board"]
    else
        # Handle failure (log the error, raise an exception, etc.)
        raise "Failed to create board. Response: #{response.body}"
    end
    end

    def self.get_boards
      api_token = ENV["MONDAY_API_TOKEN"]
      headers = { "Authorization" => api_token, "Content-Type" => "application/json" }

      query = { query: "{ boards { id name } }" }
      response = post("", body: query.to_json, headers: headers)

      if response && response["data"] && response["data"]["boards"]
        response["data"]["boards"]
      else
        raise "Failed to fetch boards. Response: #{response.body}"
      end
    end

    def self.get_board(board_id)
      api_token = ENV["MONDAY_API_TOKEN"]
      headers = { "Authorization" => api_token, "Content-Type" => "application/json" }

      query = {
        query: "
          { boards(ids: [#{board_id}]) { id name } }
        "
      }

      response = post("", body: query.to_json, headers: headers)

      # Check if the response is successful and contains the data
      if response.code == 200 && response.parsed_response["data"] && response.parsed_response["data"]["boards"]
        response.parsed_response["data"]["boards"].first
      else
        raise "Failed to fetch board. Response: #{response.body}"
      end
    end


    def self.rename_board(board_id, new_name)
      api_token = ENV["MONDAY_API_TOKEN"]
      headers = { "Authorization" => api_token, "Content-Type" => "application/json" }

      query = {
        query: "
        mutation {
          change_board_name(board_id: #{board_id}, board_name: \"#{new_name}\") {
            id
            name
          }
        }
        "
      }

      response = post("", body: query.to_json, headers: headers)

      if response && response["data"] && response["data"]["change_board_name"]
        response["data"]["change_board_name"]
      else
        raise "Failed to rename board. Response: #{response.body}"
      end
    end


    def self.delete_board(board_id)
      api_token = ENV["MONDAY_API_TOKEN"]
      headers = { "Authorization" => api_token, "Content-Type" => "application/json" }

      query = {
        query: "
          mutation {
            delete_board(board_id: #{board_id}) {
              id
            }
          }
        "
      }

      response = post("", body: query.to_json, headers: headers)

      if response && response["data"] && response["data"]["delete_board"]
        true
      else
        raise "Failed to delete board. Response: #{response.body}"
      end
    end
end
