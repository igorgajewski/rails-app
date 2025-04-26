class BoardsController < ApplicationController
  def new
    @board = Board.new
  end

  def create
    name = params[:name]
    type = params[:board_type]

    begin
      MondayService.create_board(name, type)
      redirect_to root_path, notice: "Board created successfully"
    rescue => e
      flash.now[:alert] = "Error creating board: #{e.message}"
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
      redirect_to root_path, notice: "Board renamed to #{new_name}"
    else
      flash.now[:alert] = "Error renaming board"
      render :rename
    end
  end


  # Delete a board
  def destroy
    board_id = params[:id]

    begin
      MondayService.delete_board(board_id)
      redirect_to root_path, notice: "Board deleted successfully"
    rescue => e
      flash.now[:alert] = "Error deleting board: #{e.message}"
      render :index
    end
  end

  def show
    @board = MondayService.get_board(params[:id])
  end

  private

  def board_params
    params.require(:board).permit(:name)  # Permit the necessary attributes (like 'name')
  end
end
