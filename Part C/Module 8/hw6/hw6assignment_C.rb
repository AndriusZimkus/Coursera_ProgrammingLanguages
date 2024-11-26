# University of Washington, Programming Languages, Homework 6, uw6assignment.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

# Dijkstra Liu

class MyPiece < Piece
  
  All_My_Pieces = All_Pieces + [

    rotations([[-1, -1], [0, -1], [-1, 0],[0, 0], [1, 0]]),

    [
      [[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]],
      [[0, -2], [0, -1], [0, 0], [0, 1], [0, 2]]
    ],

    rotations([[0, 0], [-1, 0], [0, 1]])
  ]

  Cheat_Piece = [[[0, 0]]]

  def self.next_piece(board)
    if board.is_cheat_active
      board.is_cheat_active = false
      MyPiece.new(Cheat_Piece, board)
    else
      MyPiece.new(All_My_Pieces.sample, board)
    end
  end

  def initialize(point_array, board)
    super(point_array, board)
  end
end

class MyBoard < Board
  attr_accessor :is_cheat_active

  def initialize(game)
    super(game)
    @cheat_pending = false
    @is_cheat_active = false
  end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def activate_cheat
    if @score >= 100 and !@is_cheat_active
      @score -= 100
      @is_cheat_active = true
      @game.update_score
    end
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    locations.each_with_index do |current, index|
      x = current[0] + displacement[0]
      y = current[1] + displacement[1]
      @grid[y][x] = @current_pos[index]
    end
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings
    super
    @root.bind('u', proc { @board.rotate_180 })
    @root.bind('c', proc { @board.activate_cheat })
  end
end