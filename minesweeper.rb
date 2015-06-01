require 'byebug'
class Board
  BOARD_SIZE = 9

  attr_accessor :grid

  #Factory method to create new board filled with "bombs" number of bombs
  def self.seed(bombs)

    grid = Array.new(9) { Array.new(9) { Tile.new } }

    #debugger
    idx = 0
    until idx == bombs do
      row, col = rand(0...BOARD_SIZE), rand(0...BOARD_SIZE)
      current_tile = grid[row][col]
      unless current_tile.bomb
        current_tile.bomb = true
        idx += 1
      end
    end

    Board.new(grid)

  end

  def initialize(grid)
    @grid = grid
  end

  def [](pos)
    row, col = pos[0], pos[1]
    self.grid[row][col]
  end

  def []=(pos)

  end


  #Displays board by showing each tile's display_value
  def display
    self.grid.map do |row|
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
    @display_value = "*"
    @flagged = flagged
    @revealed = revealed
  end



end



class Game

  def play

    puts "Enter number of bombs."


    board = Board.seed(gets.chomp.to_i)
    
    board.display



  end


end
