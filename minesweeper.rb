require 'byebug'

class Game
  def initialize
    @game_board = nil
  end

  def play
    puts "How big do you want grid? (i.e. put 9 for a 9x9 grid)"
    inputs = gets.chomp.to_i
    @game_board = Board.new(inputs)

    puts "How many bombs?"
    input = gets.chomp
    @game_board.plant_bombs(input.to_i)

    @game_board.tile_neighbors
    @game_board.tile_bomb_count

    puts "How to play?"
    puts "To reveal tile: r<tile row><tile col>"
    puts "To flag tile: f<tile row><tile col>"

    while !over?
      @game_board.display
      puts "What would you like to do? i.e. r00"
      input = gets.chomp
      self.move(input)
    end

    if lose?
      puts "You lose."
    else
      puts "You win!"
    end

    @game_board.display
  end

  def move(player_move)
    if player_move[0] == "r"
      @game_board.reveal([player_move[1].to_i,player_move[2].to_i])
    elsif player_move[0] == "f"
      @game_board.flag_tile([player_move[1].to_i,player_move[2].to_i])
    end
  end

  def over?
    lose? || won?
  end

  def won?
    if !lose?
      @game_board.grid.each do |row|
        row.each do |tile|
        return false if tile.bomb && tile.explored
        return false if !tile.bomb && !tile.explored
        end
      end
    end
    return true
  end

  def lose?
    @game_board.grid.each do |row|
      row.each do |tile|
        return true if tile.bomb && tile.explored
      end
    end
    return false
  end

end

class Board
  attr_accessor :grid

  def initialize(grid_size)
    @grid = Array.new(grid_size) { |x| Array.new(grid_size) { |y| Tile.new(self, [x,y])}}
  end

  def plant_bombs(num_of_bombs)
    i = 0
    until i == num_of_bombs
      pos_x, pos_y = rand(0..self.grid.size-1), rand(0..self.grid.size-1)
      current_tile = self.grid[pos_x][pos_y]
      if current_tile.bomb == false
        current_tile.bomb = true
        i+=1
      end
    end
    nil
  end

  def reveal(pos)
    return self if self.grid[pos[0]][pos[1]].flagged
    return self if self.grid[pos[0]][pos[1]].explored

    current_tile = self.grid[pos[0]][pos[1]]
    current_tile.explored = true

    if current_tile.neighbor_bomb_count == 0 && !current_tile.bomb
      current_tile.neighbors.each do |neighbor_pos|
        self.reveal(neighbor_pos)
      end
    end

    self
  end

  def flag_tile(pos)
    current_tile = self.grid[pos[0]][pos[1]]
    if current_tile.flagged
      current_tile.flagged = false
    else
      current_tile.flagged = true
    end
  end

  def display
    visual_display = Array.new(grid.size) { |x| Array.new(grid.size) { |y| "*"}}

    visual_display.each_with_index do |row, idx1|
      row.each_with_index do |el, idx2|
        current_tile = self.grid[idx1][idx2]
        visual_display[idx1][idx2] = "_"  if current_tile.explored
        visual_display[idx1][idx2] = "f" if current_tile.flagged
        visual_display[idx1][idx2] = "*" if !current_tile.explored && !current_tile.flagged
        if current_tile.explored && current_tile.neighbor_bomb_count > 0 && current_tile.bomb
          visual_display[idx1][idx2] = "B"
        elsif current_tile.explored && current_tile.neighbor_bomb_count
          visual_display[idx1][idx2] = current_tile.neighbor_bomb_count.to_s
        end
      end
    end

    puts "Flagged tiles: #{self.flag_count}"
    puts "Bomb tiles: #{self.board_bomb_count}"

    puts "    0    1    2    3    4    5    6    7    8"
    i = 0
    visual_display.each do |row|
      puts "#{i} #{row}"
      i+=1
    end

    nil
  end

  def tile_neighbors
    self.grid.each do |row|
      row.each do |tile|
      tile.neighbors_list
      end
    end
    nil
  end

  def tile_bomb_count
    self.grid.each do |row|
      row.each do |tile|
      tile.neighbors_bomb_count if tile.neighbor_bomb_count.nil?
      end
    end
    nil
  end


  def display_bombs
    visual_display = Array.new(grid.size) { |x| Array.new(grid.size) { |y| "*"}}

    visual_display.each_with_index do |row, idx1|
      row.each_with_index do |el, idx2|
        current_tile = self.grid[idx1][idx2]
        visual_display[idx1][idx2] = "B" if current_tile.bomb
      end
    end

    visual_display.each do |row|
      p row
    end

    nil
  end

  def flag_count
    count = 0
    self.grid.each do |row|
      row.each do |tile|
      count += 1 if tile.flagged
      end
    end
    count
  end

  def board_bomb_count
    count = 0
    self.grid.each do |row|
      row.each do |tile|
      count += 1 if tile.bomb
      end
    end
    count
  end



end

class Tile
  OFFSETS = [
    [-1,-1],
    [-1,0],
    [-1,1],
    [0,-1],
    [0,1],
    [1,-1],
    [1,0],
    [1,1]
  ]

  attr_accessor :bomb, :explored, :flagged, :pos, :board, :neighbor_bomb_count, :neighbors

  def initialize(board,pos)
    @pos = pos
    @board = board
    @bomb = false
    @flagged = false
    @explored = false
    @neighbors = nil
    @neighbor_bomb_count = nil
  end

  def neighbors_bomb_count
    bomb_count = 0
    @neighbors.each do |neighbor_pos|
      bomb_count += 1 if self.board.grid[neighbor_pos[0]][neighbor_pos[1]].bomb
    end
    @neighbor_bomb_count = bomb_count
  end

  def neighbors_list
    neighbors = []
    OFFSETS.each do |x|
      if (self.pos[0]+x[0]).between?(0,(self.board.grid.length-1)) &&
         (self.pos[1]+x[1]).between?(0,(self.board.grid.length-1))
         neighbors << [(self.pos[0]+x[0]),(self.pos[1]+x[1])]
      end
    end
    @neighbors = neighbors
  end

  def inspect
    { :pos => pos,
      :bombed => bomb?,
      :flagged => flagged?,
      :neighbors => neighbors,
      :bomb_count => neighbor_bomb_count,
      :explored => explored? }.inspect
  end


  def bomb?
    @bomb
  end

  def flagged?
    @flagged
  end

  def explored?
    @explored
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
