# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  # your enhancements here

  # class array holding all the pieces and their rotations
  #All_My_Pieces = [[[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
  #             rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
  #             [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
  #             [[0, 0], [0, -1], [0, 1], [0, 2]]],
  #             rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
  #             rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
  #             rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
  #             rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z
  #
  #             [[[0, 0], [-1, 0], [1, 0], [2, 0], [3,0]], # 5-long (two)
   #            [[0, 0], [0, -1], [0, 1], [0, 2],[0,3]]]

   #               ]

    All_My_Pieces = [
               [[[0, 0], [-1, 0], [1, 0], [2, 0], [-2,0]], # 5-long (two)
                [[0, 0], [0, -1], [0, 1], [0, 2],[0,-2]]]]
    

  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
  
end

class MyBoard < Board
  
  # your enhancements here
    def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

end

class MyTetris < Tetris
  # your enhancements here
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
  
  def key_bindings  
    @root.bind('n', proc {self.new_game}) 
    @root.bind('p', proc {self.pause}) 
    @root.bind('q', proc {exitProgram})
    @root.bind('a', proc {@board.move_left})
    @root.bind('Left', proc {@board.move_left}) 
    @root.bind('d', proc {@board.move_right})
    @root.bind('Right', proc {@board.move_right}) 
    @root.bind('s', proc {@board.rotate_clockwise})
    @root.bind('Down', proc {@board.rotate_clockwise})
    @root.bind('w', proc {@board.rotate_counter_clockwise})
    @root.bind('Up', proc {@board.rotate_counter_clockwise}) 
    @root.bind('space' , proc {@board.drop_all_the_way})
    @root.bind('u', proc {@board.rotate_clockwise; @board.rotate_clockwise })
  end

  

end


