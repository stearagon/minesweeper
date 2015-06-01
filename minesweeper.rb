require 'byebug'
class Board
  BOARD_SIZE = 9


  attr_accessor :board
  def initialize(board)
    @board = board
  end

  def self.seed(bombs)

    board = Array.new(9) { Array.new(9) { Tile.new } }

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

  def display
    debugger
    self.board.map do |row|
        row.map do |tile|
         tile.display_value
        end
    end
  end





end













class Tile

  attr_accessor :type, :display_value
  def initialize(type = nil, display_value = "_")
    @type = type
    @display_value = display_value
  end



end













class Game



end
