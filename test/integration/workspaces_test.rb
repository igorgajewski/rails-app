require "test_helper"
require "vcr"
require "webmock/minitest"

class WorkspacesTest < ActionDispatch::IntegrationTest
  test "should get list of workspaces" do
    VCR.use_cassette("workspaces/index") do
      get workspaces_path, headers: { "Accept" => "application/json" }
      assert_response :success

      response_body = JSON.parse(response.body)
      puts JSON.pretty_generate(response_body)
      assert response_body.is_a?(Array), "Response should be an array"
      assert response_body.all? { |workspace| workspace.key?("id") && workspace.key?("name") }, "Each workspace should have id and name"
    end
  end
  test "should get a specific workspace" do
    VCR.use_cassette("workspaces/show") do
      workspace_id = 10849465 # Replace with a valid workspace ID
      get workspace_path(workspace_id), headers: { "Accept" => "application/json" }
      assert_response :success

      response_body = JSON.parse(response.body)
      puts JSON.pretty_generate(response_body)
      assert response_body.is_a?(Hash), "Response should be a hash"
      assert response_body.key?("id"), "Workspace should have an id"
      assert response_body.key?("name"), "Workspace should have a name"
    end
  end
end
