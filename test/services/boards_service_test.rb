require "test_helper"

class Monday::BoardsServiceTest < ActiveSupport::TestCase
  def setup
    @service = Monday::BoardsService.new
    @mock_response = mock
    @headers = {
      "Authorization" => ENV["MONDAY_API_TOKEN"],
      "Content-Type" => "application/json"
    }
  end

  test "create_board should create a new board" do
    board_name = "Test Board"
    board_type = "public"

    @mock_response.stubs(:code).returns(200)
    @mock_response.stubs(:parsed_response).returns({
      "data" => { "create_board" => { "id" => "123", "name" => board_name } }
    })

    Monday::BoardsService.stubs(:post).returns(@mock_response)

    result = @service.create_board(board_name, board_type)
    assert_equal "123", result["id"]
    assert_equal board_name, result["name"]
  end

  test "get_boards should fetch all boards" do
    @mock_response.stubs(:code).returns(200)
    @mock_response.stubs(:parsed_response).returns({
      "data" => { "boards" => [ { "id" => "123", "name" => "Test Board" } ] }
    })

    Monday::BoardsService.stubs(:post).returns(@mock_response)

    result = @service.get_boards
    assert_equal 1, result.size
    assert_equal "123", result.first["id"]
    assert_equal "Test Board", result.first["name"]
  end

  test "get_board should fetch a specific board" do
    board_id = "123"

    @mock_response.stubs(:code).returns(200)
    @mock_response.stubs(:parsed_response).returns({
      "data" => { "boards" => [ { "id" => board_id, "name" => "Test Board" } ] }
    })
    @mock_response.stubs(:body).returns("OK")

    Monday::BoardsService.stubs(:post).returns(@mock_response)

    result = @service.get_board(board_id)
    assert_equal board_id, result["id"]
    assert_equal "Test Board", result["name"]
  end

  test "rename_board should rename a board" do
    board_id = "123"
    new_name = "Renamed Board"

    @mock_response.stubs(:parsed_response).returns({
      "data" => { "update_board" => true }
    })

    Monday::BoardsService.stubs(:post).returns(@mock_response)

    result = @service.rename_board(board_id, new_name)
    assert result
  end

  test "delete_board should delete a board" do
    board_id = "123"

    @mock_response.stubs(:parsed_response).returns({
      "data" => { "delete_board" => { "id" => board_id } }
    })

    Monday::BoardsService.stubs(:post).returns(@mock_response)

    result = @service.delete_board(board_id)
    assert result
  end
end
