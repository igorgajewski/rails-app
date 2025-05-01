class Board
  include ActiveModel::Model

  attr_accessor :id, :name, :board_type, :owners, :workspace, :items
end
