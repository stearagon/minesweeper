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

  def [](row,col)
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

  def initialize(board)
    @board = board
  end

  def self.play
    #creates game board with input from user for number of bombs
    puts "Enter number of bombs."



    new_game = Game.new(Board.seed(gets.chomp.to_i))

    until new_game.over?
      @board.display
      new_game.move

    end

    if win?
      puts "You win!"
    else
      puts "You lose"
    end

  end

  def over?
    win? || lose?
    #user picks tile that is bomb, or user reveals all other tiles
  end

  def lose?
    false

  end

  def win?
    false
  end

  def move
    puts "Select tile with r/f and position"
    input = gets.chomp.split("")
    row, col = input[1].to_i, input[2].to_i
    if input[0] == "r"
      #reveal tile at specified location
      @board[row,col].revealed == true
    elsif input[0] == "f"
      #flag tile at location
      @board[row,col].flagged == true
    end
  end



end
