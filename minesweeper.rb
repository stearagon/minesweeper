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

    new_board = Board.new(grid)

    new_board.grid.each_with_index do |row, idx1|
      row.each_with_index do |tile, idx2|
        tile.board = new_board
        tile.pos = [idx1,idx2]
      end
    end

    new_board

  end

  def initialize(grid)
    @grid = grid
  end

  def [](row,col)
    self.grid[row][col]
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
  OFFSET_POSITIONS = [
                      [-1,-1],[0,-1],[1,-1],
                      [-1,0],        [1,0],
                      [-1,1],[0,1],[1,1]
                     ]

  attr_accessor :bomb, :display_value, :flagged, :revealed, :board, :pos

  def initialize(
                  bomb = false,
                  flagged = false,
                  revealed = false,
                )
    @bomb = bomb
    @display_value = "*"
    @flagged = flagged
    @revealed = revealed
    @board = nil
    @neighbors = []
    @pos = nil
  end

  def neighbors
    neighbors = []
    OFFSET_POSITIONS.each do |x|
      row = (x[0] + self.pos[0])
      col = (x[1] + self.pos[1])
      neighbors << [row, col] if row.between?(0,8) && col.between?(0,8)
    end
    neighbors
  end


end



class Game

  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def self.play
    #creates game board with input from user for number of bombs
    puts "Enter number of bombs."



    new_game = Game.new(Board.seed(gets.chomp.to_i))

    until new_game.over?

      new_game.board.display.each do |row|
        puts row.inspect
      end
      new_game.move

    end

    if new_game.win?
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
    @board.grid.each do |row|
      row.each do |tile|
        return true if tile.bomb && tile.revealed
      end
    end

    false
  end

  def win?
    @board.grid.each do |row|
      row.each do |tile|
        return false if !tile.bomb && !tile.revealed
      end
    end

    true
  end

  def move
    puts "Select tile with r/f and position"
    input = gets.chomp.split("")
    row, col = input[1].to_i, input[2].to_i

    if input[0] == "r"
      #reveal tile at specified location
      @board[row,col].revealed = true
      @board[row,col].display_value = "_"
    elsif input[0] == "f"
      #flag tile at location if not revealed
      unless @board[row,col].revealed == true
        @board[row,col].flagged = true
        @board[row,col].display_value = "f"
      end

      #unflag if already flagged
      if @board[row,col].flagged = true
        @board[row,col].flagged = false
        @board[row,col].display_value = "*"
      end
    end
  end



end
