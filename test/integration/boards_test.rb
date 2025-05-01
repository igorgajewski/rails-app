require "test_helper"
require "vcr"
require "webmock/minitest"

class BoardsTest < ActionDispatch::IntegrationTest
  test "should get list of boards" do
    VCR.use_cassette("boards/index") do
      get boards_path, headers: { "Accept" => "application/json" }
      assert_response :success

      response_body = JSON.parse(response.body)
      puts "response_body: #{response_body}"
      assert response_body.is_a?(Array), "Response should be an array"
      assert response_body.all? { |board| board.key?("id") && board.key?("name") }, "Each board should have id and name"
    end
  end
  test "should get a specific board" do
    VCR.use_cassette("boards/show") do
      board_id = 10782788 # Replace with a valid workspace ID
      get workspace_path(board_id), headers: { "Accept" => "application/json" }
      assert_response :success

      response_body = JSON.parse(response.body)
      puts JSON.pretty_generate(response_body)
      assert response_body.is_a?(Hash), "Response should be a hash"
      assert response_body.key?("id"), "Board should have an id"
      assert response_body.key?("name"), "Board should have a name"
    end
  end
  test "should create a new workspace" do
    VCR.use_cassette("boards/create") do
      post workspaces_path, params: { name: "New Workspace", description: "Test description" }, headers: { "Accept" => "application/json" }
      assert_response :redirect

      follow_redirect!
      assert_response :success
      assert_match /Workspace created successfully/, response.body
    end
  end
  test "should update an existing workspace" do
    VCR.use_cassette("workspaces/update") do
      workspace_id = 12345 # Replace with a valid workspace ID
      patch workspace_path(workspace_id), params: { name: "Updated Workspace" }, headers: { "Accept" => "application/json" }
      assert_response :redirect

      follow_redirect!
      assert_response :success
      assert_match /Workspace renamed to Updated Workspace/, response.body
    end
  end
  test "should delete a workspace" do
    VCR.use_cassette("workspaces/destroy") do
      workspace_id = 12345 # Replace with a valid workspace ID
      delete workspace_path(workspace_id), headers: { "Accept" => "application/json" }
      assert_response :redirect

      follow_redirect!
      assert_response :success
      assert_match /Workspace deleted successfully/, response.body
    end
  end
end
