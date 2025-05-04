class HomeController < ApplicationController
  def index
    @boards = Monday::BoardsService.new.get_boards
  end
end
