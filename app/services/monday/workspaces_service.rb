# app/services/monday/workspaces_service.rb

module Monday
  class WorkspacesService
    include HTTParty
    base_uri "https://api.monday.com/v2"

    def initialize
      @api_token = ENV["MONDAY_API_TOKEN"]
      @headers = {
        "Authorization" => @api_token,
        "Content-Type" => "application/json"
      }
    end

    def create_workspace(name, description)
      query = {
        query: "
          mutation {
            create_workspace (name: \"#{name}\", description: \"#{description}\", kind: open) {
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

    def get_workspaces
      query = { query: "{ workspaces { id name } }" }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response && response.parsed_response["data"] && response.parsed_response["data"]["workspaces"]
        response.parsed_response["data"]["workspaces"]
      else
        raise "Failed to fetch workspaces. Response: #{response.body}"
      end
    end

    def get_workspace(workspace_id)
      query = {
        query: "
          { workspaces(ids: [#{workspace_id}]) {
              id
              name
              state
          }}
        "
      }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response.code == 200 && response.parsed_response["data"] && response.parsed_response["data"]["workspaces"]
        response.parsed_response["data"]["workspaces"].first
      else
        raise "Failed to fetch board. Response: #{response.body}"
      end
    end

    def rename_workspace(workspace_id, new_name)
      query = {
        query: "
          mutation {
            update_workspace(id: #{board_id}, attributes: {name, new_value: \"#{new_name}\"}){id}
          }
        "
      }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response.parsed_response["data"] && response.parsed_response["data"]["update_workspace"]
        true
      else
        raise "Failed to update workspace. Response: #{response.body}"
      end
    end

    def delete_workspace(workspace_id)
      query = {
        query: "
          mutation {
            delete_workspace(workspace_id: #{workspace_id}) {
              id
            }
          }
        "
      }

      response = self.class.post("", body: query.to_json, headers: @headers)

      if response.parsed_response["data"] && response.parsed_response["data"]["delete_workspace"]
        true
      else
        raise "Failed to delete workspace. Response: #{response.body}"
      end
    end
  end
end
