class Board
  BOARD_SIZE = 9


  attr_accessor :board
  def initialize(board)
    @board = board
  end

  def self.seed(bombs)

    board = Array.new(9) { |row| Array.new(9) { |col| Tile.new } }

    idx = 0
    until idx == bombs do
      row, col = rand(0...BOARD_SIZE), rand(0...BOARD_SIZE)
      current_tile = board[row][col]
      unless current_tile.type == :bomb
        current_tile.type = :bomb
        idx += 1
      end
    end

    Board.new(board)

  end





end













class Tile

  attr_accessor :type
  def initialize(type = nil)
    @type = type

  end



end













class Game



end
