class Board
  BOARD_SIZE = 9


  attr_accessor :board
  def initialize(board)
    @board = board
  end

  def self.seed(bombs)

    board = Array.new(9) { Array.new(9) { "_" } }

    bombs.times do |x|
      row, col = rand(0...BOARD_SIZE), rand(0...BOARD_SIZE)
      
    end

    Board.new(board)

  end





end













class Tile




end













class Game



end
