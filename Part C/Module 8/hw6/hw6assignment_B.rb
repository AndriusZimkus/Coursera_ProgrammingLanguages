# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece



  def initialize (point_array, board)
      super(point_array, board)
      @block_size = point_array[0].size
  end

  attr_accessor :block_size

  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
               rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
               [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
               [[0, 0], [0, -1], [0, 1], [0, 2]]],
               rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
               rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
               rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
               rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
               rotations([[0, 0], [1, 0], [0, 1], [1, 1], [2, 1]]), #2x3
               [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]], #5x1
               [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]], #5x1
               rotations([[0,0], [0, 1], [1,1]])] # corner

  # your enhancements here

  def self.next_piece (board)
      MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.next_cheat_piece (board)
    MyPiece.new([[[0, 0]]], board)
  end

end


class MyBoard < Board
  attr_accessor :score, :cheat
  # your enhancements here

  def initialize (game)
      super(game)
      @current_block = MyPiece.next_piece(self)
      @cheat = false
  end

  #rotates the current piece 180 degrees
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def use_cheat
    if @score >= 100 and @cheat == false
      @score = @score - 100;
      @cheat = true
    end
  end


  def next_piece
      if @cheat
        @current_block = MyPiece.next_cheat_piece(self)
        @cheat = false
      else
          @current_block = MyPiece.next_piece(self)
      end
      @current_pos = nil
  end

  def store_current
      locations = @current_block.current_rotation
      displacement = @current_block.position
      block_size = @current_block.block_size
      (0..block_size-1).each{|index|
        current = locations[index];
        @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
        @current_pos[index]
      }
      remove_filled
      @delay = [@delay - 2, 80].max
    end

end

class MyTetris < Tetris

  # your enhancements here

 def key_bindings
     @root.bind('u', proc {@board.rotate_180})
     @root.bind('c', proc {@board.use_cheat})
     super()
 end

 def set_board
     @canvas = TetrisCanvas.new
     @board = MyBoard.new(self)
     @canvas.place(@board.block_size * @board.num_rows + 3,
                   @board.block_size * @board.num_columns + 6, 24, 80)
     @board.draw
 end

end