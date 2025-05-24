# University of Washington, Programming Languages, Homework 7, hw7.rb 
# (See also ML code)

# a little language for 2D geometry objects

# each subclass of GeometryExpression, including subclasses of GeometryValue,
#  needs to respond to messages preprocess_prog and eval_prog
#
# each subclass of GeometryValue additionally needs:
#   * shift
#   * intersect, which uses the double-dispatch pattern
#   * intersectPoint, intersectLine, and intersectVerticalLine for 
#       for being called by intersect of appropriate clases and doing
#       the correct intersection calculuation
#   * (We would need intersectNoPoints and intersectLineSegment, but these
#      are provided by GeometryValue and should not be overridden.)
#   *  intersectWithSegmentAsLineResult, which is used by 
#      intersectLineSegment as described in the assignment
#
# you can define other helper methods, but will not find much need to

# Note: geometry objects should be immutable: assign to fields only during
#       object construction

# Note: For eval_prog, represent environments as arrays of 2-element arrays
# as described in the assignment

class GeometryExpression  
  # do *not* change this class definition
  Epsilon = 0.00001
end

class GeometryValue 
  # do *not* change methods in this class definition
  # you can add methods if you wish

  private
  # some helper methods that may be generally useful
  def real_close(r1,r2) 
    (r1 - r2).abs < GeometryExpression::Epsilon
  end
  def real_close_point(x1,y1,x2,y2) 
    real_close(x1,x2) && real_close(y1,y2)
  end
  # two_points_to_line could return a Line or a VerticalLine
  def two_points_to_line(x1,y1,x2,y2) 
    if real_close(x1,x2)
      VerticalLine.new x1
    else
      m = (y2 - y1).to_f / (x2 - x1)
      b = y1 - m * x1
      Line.new(m,b)
    end
  end

  public
  # we put this in this class so all subclasses can inherit it:
  # the intersection of self with a NoPoints is a NoPoints object
  def intersectNoPoints np
    np # could also have NoPoints.new here instead
  end

  # we put this in this class so all subclasses can inhert it:
  # the intersection of self with a LineSegment is computed by
  # first intersecting with the line containing the segment and then
  # calling the result's intersectWithSegmentAsLineResult with the segment
  def intersectLineSegment seg
    line_result = intersect(two_points_to_line(seg.x1,seg.y1,seg.x2,seg.y2))
    line_result.intersectWithSegmentAsLineResult seg
  end

  # moved from NoPoints provided class - it is the same for all GeometryValues
  def eval_prog env 
    self # all values evaluate to self
  end
  # moved from NoPoints provided class - it is the same for all GeometryValues except LineSegment
  def preprocess_prog
    self # no pre-processing to do here
  end
end

class NoPoints < GeometryValue
  # do *not* change this class definition: everything is done for you
  # (although this is the easiest class, it shows what methods every subclass
  # of geometry values needs)
  # However, you *may* move methods from here to a superclass if you wish to

  # Note: no initialize method only because there is nothing it needs to do
  # NOTE: moved eval_prog and preprocess_prog as all values have the same implementation

  def shift(dx,dy)
    self # shifting no-points is no-points
  end
  def intersect other
    other.intersectNoPoints self # will be NoPoints but follow double-dispatch
  end
  def intersectPoint p
    self # intersection with point and no-points is no-points
  end
  def intersectLine line
    self # intersection with line and no-points is no-points
  end
  def intersectVerticalLine vline
    self # intersection with line and no-points is no-points
  end
  # if self is the intersection of (1) some shape s and (2) 
  # the line containing seg, then we return the intersection of the 
  # shape s and the seg.  seg is an instance of LineSegment
  def intersectWithSegmentAsLineResult seg
    self
  end
end


class Point < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods

  # Note: You may want a private helper method like the local
  # helper function inbetween in the ML code
  private
  def inbetween(v, end1, end2)
     ((end1 - GeometryExpression::Epsilon <= v) &
        (v <= end2 + GeometryExpression::Epsilon)) |
      ((end2 - GeometryExpression::Epsilon <= v) & 
        (v <= end1 + GeometryExpression::Epsilon))
  end

  public
  attr_reader :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def shift(dx,dy)
    Point.new(@x + dx, @y + dy)
  end

  def intersect other
    other.intersectPoint self # dispatch
  end
  
  def intersectPoint p
    if real_close_point(p.x, p.y, @x, @y)
    then self
    else NoPoints.new
    end
  end
  
  def intersectLine line
    if real_close(@y, line.m * @x + line.b)
    then self
    else NoPoints.new
    end
  end

  def intersectVerticalLine vline
    if real_close(@x, vline.x)
    then self
    else NoPoints.new
    end
  end

  def intersectWithSegmentAsLineResult seg
    if inbetween(@x, seg.x1, seg.x2) & inbetween(@y, seg.y1, seg.y2)
    then self # same point is the intersect
    else NoPoints.new
    end 
  end
end

class Line < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :m, :b 
  def initialize(m,b)
    @m = m
    @b = b
  end

  def shift(dx,dy)
    Line.new(@m, (@b + dy) - (@m * dx))
  end

  def intersect other
    other.intersectLine self # dispatch
  end
  
  def intersectPoint p
    p.intersectLine self # reuse the implementation of point (commutative)
  end
  
  def intersectLine line
    if real_close(@m,line.m)
    then if real_close(@b, line.b)
         then self # same line
         else NoPoints.new # parallel lines do not i8ntersect
         end
    else
      x = (line.b - @b) / (@m - line.m)
      y = @m * x + @b
      Point.new(x, y) # one point intersection
    end
  end

  def intersectVerticalLine vline
    Point.new(vline.x, @m * vline.x + @b)
  end

  def intersectWithSegmentAsLineResult seg
    seg # so segment seg is on this line
  end
end

class VerticalLine < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :x
  def initialize x
    @x = x
  end

  def shift(dx,dy)
    VerticalLine.new(@x + dx)
  end

  def intersect other
    other.intersectVerticalLine self # dispatch
  end
  
  def intersectPoint p
    p.intersectVerticalLine self # reuse the implementation of point (commutative)
  end
  
  def intersectLine line
    line.intersectVerticalLine self # reuse the implementation of line (commutative)
  end

  def intersectVerticalLine vline
    if real_close(@x, vline.x)
    then self # same line
    else NoPoints.new # parallel
    end
  end

  def intersectWithSegmentAsLineResult seg
    seg # so segment seg is on this vertical line
  end
end

class LineSegment < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  # Note: This is the most difficult class.  In the sample solution,
  #  preprocess_prog is about 15 lines long and 
  # intersectWithSegmentAsLineResult is about 40 lines long
  attr_reader :x1, :y1, :x2, :y2
  def initialize (x1,y1,x2,y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
  end

  # overriden to ensure first point before second based on the rules
  def preprocess_prog
    x_same = real_close(@x1,@x2)
    y_same = real_close(@y1,@y2)
    if (x_same & y_same) then
      Point.new(@x1,@y1)
    elsif ((@x1 < @x2) | (x_same & (@y1 < @y2)))
      self
    else
      LineSegment.new(@x2,@y2,@x1,@y1)
    end
  end

  def shift(dx,dy)
    LineSegment.new(@x1 + dx, @y1 + dy, @x2 + dx, @y2 + dy)
  end

  def intersect other
    other.intersectLineSegment self # dispatch
  end

  def intersectPoint p
    intersect p
  end

  def intersectLine l
    intersect l
  end

  def intersectVerticalLine vl
    intersect vl
  end

  # the hard case in the hard case: this and seg are on teh same line (or vertical line)
  # but they could be (1) disjoint or (2) overlapping or (3) one side the other
  # or (4) just touching. And we treat vertical segments differently, so there are 4*2 cases.
  def intersectWithSegmentAsLineResult seg
    if real_close(@x1,seg.x2) then # the segments are on a vertical line
      if @y1 < seg.y2 then # let segment a start at or below start of segment b
        a = self
        b = seg
      else
        a = seg
        b = self
      end
      if real_close(a.y2, b.y1) then
        Point.new(a.x2,a.y2) # just touching
      elsif a.y2 < b.y1 then
        NoPoints.new # disjoint
      elsif a.y2 > b.y2 then
        b # b inside a
      else
        LineSegment.new(b.x1, b.y1, a.x2, a.y2) # overlapping
      end
    else # the segments are on a non-vertical line
      if @x1 < seg.x1 then # let the segment a start at or to the left of start of segment b
        a = self
        b = seg
      else
        a = seg
        b = self
      end
      if real_close(a.x2, b.x1) then
        Point.new(a.x2,a.y2) # just touching
      elsif a.x2 < b.x1
        NoPoints.new
      elsif a.x2 > b.x2
        b # b inside a
      else
        LineSegment.new(b.x1,b.y1,a.x2,a.y2) # overlapping
      end
    end
  end
end

# Note: there is no need for getter methods for the non-value classes

class Intersect < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end

  def preprocess_prog
    Intersect.new(@e1.preprocess_prog, @e2.preprocess_prog) # preprocess sub-expressions
  end
  
  def eval_prog env
    v1 = @e1.eval_prog env
    v2 = @e2.eval_prog env
    v1.intersect v2
  end
end

class Let < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  # Note: Look at Var to guide how you implement Let
  def initialize(s,e1,e2)
    @s = s
    @e1 = e1
    @e2 = e2
  end

  def preprocess_prog
    Let.new(@s, @e1.preprocess_prog, @e2.preprocess_prog) # preprocess sub-expressions
  end

  def eval_prog env
    val = @e1.eval_prog env # evaluate binding value
    new_env = [[@s, val]] + env # create new environment
    @e2.eval_prog new_env # evaluate in the new environment
  end

end

class Var < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize s
    @s = s
  end
  def eval_prog env # remember: do not change this method
    pr = env.assoc @s
    raise "undefined variable" if pr.nil?
    pr[1]
  end

  def preprocess_prog
    self # no pre-processing to do here
  end
end

class Shift < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(dx,dy,e)
    @dx = dx
    @dy = dy
    @e = e
  end

  def preprocess_prog
    Shift.new(@dx, @dy, @e.preprocess_prog) # preprocess sub-expressions
  end

  def eval_prog env
    val = @e.eval_prog env # evaluate on the environment
    val.shift(@dx, @dy) # dispatch the shift
  end

end
