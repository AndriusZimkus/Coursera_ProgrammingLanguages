# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here

  # your enhancements here

end

class MyBoard < Board
  # your enhancements here

end

class MyTetris < Tetris
  # your enhancements here

  def key_bindings  
    #@root.bind('n', proc {self.new_game}) 

    #@root.bind('p', proc {self.pause}) 

    #@root.bind('q', proc {exitProgram})
    
    #@root.bind('a', proc {@board.move_left})
    #@root.bind('Left', proc {@board.move_left}) 
    
    #@root.bind('d', proc {@board.move_right})
    #@root.bind('Right', proc {@board.move_right}) 

    #@root.bind('s', proc {@board.rotate_clockwise})
    #@root.bind('Down', proc {@board.rotate_clockwise})

    #@root.bind('w', proc {@board.rotate_counter_clockwise})
    @root.bind('Up', proc {@board.rotate_counter_clockwise}) 
    
    @root.bind('space' , proc {@board.drop_all_the_way})
    @root.bind('u', proc {@board.rotate_clockwise; @board.rotate_clockwise })
  end

  

end


