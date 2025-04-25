class BoardsController < ApplicationController
  def new
  end

  def create
    name = params[:name]
    type = params[:board_type]

    # Call Monday API here (use HTTParty, Faraday, or Net::HTTP)
    response = MondayService.create_board(name, type)

    # Check if the response contains the expected board data
    if response && response["id"] && response["name"]
      redirect_to new_board_path, notice: "Board created: #{response['name']} (#{response['id']})"
    else
      flash.now[:alert] = "Error creating board"
      render :new
    end
  end

  # Show all boards
  def index
    @boards = MondayService.get_boards
  end
  def rename
    board_id = params[:id]
    @board = MondayService.get_board(board_id) # Fetch the board from the API
  end

  def update
    board_id = params[:id]
    new_name = params[:name]

    response = MondayService.rename_board(board_id, new_name)

    if response
      redirect_to boards_path, notice: "Board renamed to #{new_name}"
    else
      flash.now[:alert] = "Error renaming board"
      render :rename
    end
  end


  # Delete a board
  def destroy
    board_id = params[:id]

    response = MondayService.delete_board(board_id)
    if response.success?
      redirect_to boards_path, notice: "Board deleted successfully"
    else
      flash.now[:alert] = "Error deleting board"
      render :index
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)  # Permit the necessary attributes (like 'name')
  end
end
