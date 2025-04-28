require "test_helper"
require "mocha/minitest"
require "ostruct"
require "httparty"

class MondayServiceTest < ActiveSupport::TestCase
  test "create_board success" do
    fake_response = OpenStruct.new(
      code: 200,
      parsed_response: { "data" => { "create_board" => { "id" => "123", "name" => "Test Board" } } }
    )

    MondayService.expects(:post).returns(fake_response)

    board = MondayService.create_board("Test Board", "public")

    assert_equal "123", board["id"]
    assert_equal "Test Board", board["name"]
  end
  test "create_board failure" do
    fake_response = OpenStruct.new(
      code: 400,
      body: "Invalid request"
    )

    MondayService.expects(:post).returns(fake_response)

    assert_raises RuntimeError, "Failed to create board. Response: Invalid request" do
      MondayService.create_board("Test Board", "public")
    end
  end

  test "get_boards success" do
    fake_response = { "data" => { "boards" => [ { "id" => "1", "name" => "Board 1" } ] } }
    MondayService.expects(:post).returns(fake_response)

    boards = MondayService.get_boards

    assert_equal 1, boards.length
    assert_equal "Board 1", boards.first["name"]
  end
  test "get_boards failure" do
    fake_response = OpenStruct.new(
      code: 400,
      body: "Invalid request"
    )

    MondayService.expects(:post).returns(fake_response)

    assert_raises RuntimeError, "Failed to fetch boards. Response: Invalid request" do
      MondayService.get_boards
    end
  end

  test "get_board success" do
    fake_response = OpenStruct.new(
      code: 200,
      parsed_response: { "data" => { "boards" => [ { "id" => "1", "name" => "Board 1" } ] } }
    )

    MondayService.expects(:post).returns(fake_response)

    board = MondayService.get_board(1)

    assert_equal "1", board["id"]
    assert_equal "Board 1", board["name"]
  end

  test "rename_board success" do
    fake_response = { "data" => { "update_board" => true } }
    MondayService.expects(:post).returns(fake_response)

    result = MondayService.rename_board(1, "New Name")

    assert_equal true, result
  end

  test "delete_board success" do
    fake_response = { "data" => { "delete_board" => { "id" => "1" } } }
    MondayService.expects(:post).returns(fake_response)

    result = MondayService.delete_board(1)

    assert_equal true, result
  end
end
