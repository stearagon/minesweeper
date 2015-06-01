require 'byebug'
class Board
  BOARD_SIZE = 9

  attr_accessor :board

  #Factory method to create new board filled with "bombs" number of bombs
  def self.seed(bombs)

    board = Array.new(9) { Array.new(9) { Tile.new } }

    idx = 0
    until idx == bombs do
      row, col = rand(0...BOARD_SIZE), rand(0...BOARD_SIZE)
      current_tile = board[row][col]
      unless current_tile.bomb == true
        current_tile.bomb = true
        idx += 1
      end
    end

    Board.new(board)

  end

  def initialize(board)
    @board = board
  end

  def [](pos)
    row, col = pos[0], pos[1]
    @board[row][col]
  end
  
  def []=(row,col)

  end


  #Displays board by showing each tile's display_value
  def display
    self.board.map do |row|
        row.map do |tile|
         tile.display_value
        end
    end
  end

end


class Tile

  attr_accessor :bomb, :display_value, :flagged, :revealed

  def initialize(
                  bomb = false,
                  flagged = false,
                  revealed = false
                )
    @bomb = bomb
    @display_value = "_"
    @flagged = flagged
    @reveled = revealed
  end


end



class Game



end
