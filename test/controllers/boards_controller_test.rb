require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_board_path
    assert_response :success
  end

  test "should create board" do
    post boards_path, params: { name: "Test Board", board_type: "public" }
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
