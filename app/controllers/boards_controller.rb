class BoardsController < ApplicationController
  def new
    @board = Board.new
  end

  def create
    name = params[:name]
    type = params[:board_type]

    begin
      Monday::BoardsService.new.create_board(name, type)
      redirect_to root_path, notice: "Board created successfully"
    rescue => e
      flash.now[:alert] = "Error creating board: #{e.message}"
      render :new
    end
  end

  # Show all boards
  def index
    @boards = Monday::BoardsService.new.get_boards

    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @workspaces }
    end
  end


  def edit
    @board = Monday::BoardsService.new.get_board(params[:id]) # assuming you have such a method, or reuse similar
  end

  def update
    board_id = params[:id]
    new_name = params[:name]

    begin
      Monday::BoardsService.new.rename_board(board_id, new_name)
      redirect_to boards_path, notice: "Board renamed to #{new_name}"
    rescue => e
      flash.now[:alert] = "Error renaming board: #{e.message}"
      render :edit
    end
  end


  # Delete a board
  def destroy
    board_id = params[:id]

    begin
      Monday::BoardsService.new.delete_board(board_id)
      redirect_to boards_path, notice: "Board deleted successfully"
    rescue => e
      flash.now[:alert] = "Error deleting board: #{e.message}"
      render :index
    end
  end

  def show
    @board = Monday::BoardsService.new.get_board(params[:id])

    respond_to do |format|
      format.html # renders index.html.erb
      format.json { render json: @workspaces }
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)  # Permit the necessary attributes (like 'name')
  end
end
