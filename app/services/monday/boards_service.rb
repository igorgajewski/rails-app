# app/services/monday/boards_service.rb

module Monday
  class BoardsService
    include HTTParty
    base_uri "https://api.monday.com/v2"

    def initialize
      @api_token = ENV["MONDAY_API_TOKEN"]
      @headers = {
        "Authorization" => @api_token,
        "Content-Type" => "application/json"
      }
    end

    def create_board(name, board_type)
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

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response.code == 200 && response.parsed_response["data"]
        response.parsed_response["data"]["create_board"]
      else
        raise "Failed to create board. Response: #{response.body}"
      end
    end

    def get_boards
      query = { query: "{ boards { id name } }" }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response && response.parsed_response["data"] && response.parsed_response["data"]["boards"]
        response.parsed_response["data"]["boards"]
      else
        raise "Failed to fetch boards. Response: #{response.body}"
      end
    end

    def get_board(board_id)
      query = {
        query: "
          { boards(ids: [#{board_id}]) {
              id
              name
              owners { id name }
              workspace { id name }
              items_page(
              query_params: {
              rules: [
              ],
              operator: and
    })
    {
      items{
        id name
      }
    }
          }}
        "
      }

      response = self.class.post("", body: query.to_json, headers: @headers)
      puts "TEST Response: #{response.body}"

      if response.code == 200 && response.parsed_response["data"] && response.parsed_response["data"]["boards"]
        response.parsed_response["data"]["boards"].first
      else
        raise "Failed to fetch board. Response: #{response.body}"
      end
    end

    def rename_board(board_id, new_name)
      query = {
        query: "
          mutation {
            update_board(board_id: #{board_id}, board_attribute: name, new_value: \"#{new_name}\")
          }
        "
      }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response.parsed_response["data"] && response.parsed_response["data"]["update_board"]
        true
      else
        raise "Failed to update board. Response: #{response.body}"
      end
    end

    def delete_board(board_id)
      query = {
        query: "
          mutation {
            delete_board(board_id: #{board_id}) {
              id
            }
          }
        "
      }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response.parsed_response["data"] && response.parsed_response["data"]["delete_board"]
        true
      else
        raise "Failed to delete board. Response: #{response.body}"
      end
    end
  end
end
