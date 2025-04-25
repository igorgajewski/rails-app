class HomeController < ApplicationController
  def index
    @boards = MondayService.get_boards
  end
end
