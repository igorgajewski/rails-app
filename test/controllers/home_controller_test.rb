require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    # Mock the response of the MondayService.get_boards method
    MondayService.stubs(:get_boards).returns([ { "id" => "1", "name" => "Test Board" } ])

    get root_url
    assert_response :success

    # You can also check if the board's name is rendered in the response
    assert_match "Test Board", @response.body
  end
end
