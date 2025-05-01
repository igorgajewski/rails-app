class HomeController < ApplicationController
  def index
    @boards = Monday::MondayService.get_boards
  end
end
