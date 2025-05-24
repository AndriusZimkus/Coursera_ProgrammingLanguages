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
end

class NoPoints < GeometryValue
  # do *not* change this class definition: everything is done for you
  # (although this is the easiest class, it shows what methods every subclass
  # of geometry values needs)
  # However, you *may* move methods from here to a superclass if you wish to

  # Note: no initialize method only because there is nothing it needs to do
  def eval_prog env 
    self # all values evaluate to self
  end
  def preprocess_prog
    self # no pre-processing to do here
  end
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
  attr_reader :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end
  
  def eval_prog env
    self # all values evaluate to self
  end
  
  def preprocess_prog
    self # no pre-processing for points
  end
  
  def shift(dx,dy)
    Point.new(x + dx, y + dy)
  end
  
  def intersect other
    other.intersectPoint self # double-dispatch
  end
  
  def intersectPoint p
    if real_close_point(x, y, p.x, p.y)
      self # same point
    else
      NoPoints.new # different points
    end
  end
  
  def intersectLine line
    if real_close(y, line.m * x + line.b)
      self # point is on the line
    else
      NoPoints.new # point is not on the line
    end
  end
  
  def intersectVerticalLine vline
    if real_close(x, vline.x)
      self # point is on the vertical line
    else
      NoPoints.new # point is not on the vertical line
    end
  end
  
  def intersectWithSegmentAsLineResult seg
    # Check if point is within the segment bounds
    if inbetween(x, seg.x1, seg.x2) && inbetween(y, seg.y1, seg.y2)
      self
    else
      NoPoints.new
    end
  end
  
  private
  
  def inbetween(v, end1, end2)
    (end1 - GeometryExpression::Epsilon <= v && v <= end2 + GeometryExpression::Epsilon) ||
    (end2 - GeometryExpression::Epsilon <= v && v <= end1 + GeometryExpression::Epsilon)
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
  
  def eval_prog env
    self # all values evaluate to self
  end
  
  def preprocess_prog
    self # no pre-processing for lines
  end
  
  def shift(dx,dy)
    Line.new(m, b + dy - m * dx)
  end
  
  def intersect other
    other.intersectLine self # double-dispatch
  end
  
  def intersectPoint p
    p.intersectLine self # commutative
  end
  
  def intersectLine line
    if real_close(m, line.m)
      if real_close(b, line.b)
        self # same line
      else
        NoPoints.new # parallel lines
      end
    else
      # one-point intersection
      x = (line.b - b) / (m - line.m)
      y = m * x + b
      Point.new(x, y)
    end
  end
  
  def intersectVerticalLine vline
    Point.new(vline.x, m * vline.x + b)
  end
  
  def intersectWithSegmentAsLineResult seg
    seg # if segment is on line, the intersection is the segment itself
  end
end

class VerticalLine < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :x
  def initialize x
    @x = x
  end
  
  def eval_prog env
    self # all values evaluate to self
  end
  
  def preprocess_prog
    self # no pre-processing for vertical lines
  end
  
  def shift(dx,dy)
    VerticalLine.new(x + dx)
  end
  
  def intersect other
    other.intersectVerticalLine self # double-dispatch
  end
  
  def intersectPoint p
    p.intersectVerticalLine self # commutative
  end
  
  def intersectLine line
    line.intersectVerticalLine self # commutative
  end
  
  def intersectVerticalLine vline
    if real_close(x, vline.x)
      self # same vertical line
    else
      NoPoints.new # parallel vertical lines
    end
  end
  
  def intersectWithSegmentAsLineResult seg
    seg # if segment is on vertical line, the intersection is the segment itself
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
  
  def eval_prog env
    self # all values evaluate to self
  end
  
  def preprocess_prog
    if real_close_point(x1, y1, x2, y2)
      Point.new(x1, y1) # segment is actually a point
    elsif real_close(x1, x2) # vertical segment
      if y1 > y2
        LineSegment.new(x1, y2, x2, y1) # swap to have lower y first
      else
        self
      end
    elsif x1 > x2
      LineSegment.new(x2, y2, x1, y1) # swap to have lower x first
    else
      self
    end
  end
  
  def shift(dx,dy)
    LineSegment.new(x1 + dx, y1 + dy, x2 + dx, y2 + dy)
  end
  
  def intersect other
    other.intersectLineSegment self # double-dispatch
  end
  
  def intersectPoint p
    p.intersectLineSegment self # commutative
  end
  
  def intersectLine line
    line.intersectLineSegment self # commutative
  end
  
  def intersectVerticalLine vline
    vline.intersectLineSegment self # commutative
  end
  
  def intersectWithSegmentAsLineResult seg
    # This is the most complex method
    # Check if segments are on a vertical line
    if real_close(x1, x2)
      # vertical segments
      # Order segments by y-coordinate (a below b)
      if y1 < seg.y1
        aY1, aY2, bY1, bY2 = y1, y2, seg.y1, seg.y2
        aX, bX = x1, seg.x1
      else
        aY1, aY2, bY1, bY2 = seg.y1, seg.y2, y1, y2
        aX, bX = seg.x1, x1
      end
      
      if real_close(aY2, bY1)
        Point.new(aX, aY2) # just touching
      elsif aY2 < bY1
        NoPoints.new # disjoint
      elsif aY2 > bY2
        LineSegment.new(bX, bY1, bX, bY2) # b inside a
      else
        LineSegment.new(bX, bY1, aX, aY2) # overlapping
      end
    else
      # non-vertical segments
      # Order segments by x-coordinate (a to the left of b)
      if x1 < seg.x1
        aX1, aY1, aX2, aY2 = x1, y1, x2, y2
        bX1, bY1, bX2, bY2 = seg.x1, seg.y1, seg.x2, seg.y2
      else
        aX1, aY1, aX2, aY2 = seg.x1, seg.y1, seg.x2, seg.y2
        bX1, bY1, bX2, bY2 = x1, y1, x2, y2
      end
      
      if real_close(aX2, bX1)
        Point.new(aX2, aY2) # just touching
      elsif aX2 < bX1
        NoPoints.new # disjoint
      elsif aX2 > bX2
        LineSegment.new(bX1, bY1, bX2, bY2) # b inside a
      else
        LineSegment.new(bX1, bY1, aX2, aY2) # overlapping
      end
    end
  end
end

class Intersect < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end
  
  def eval_prog env
    v1 = @e1.eval_prog(env)
    v2 = @e2.eval_prog(env)
    v1.intersect(v2)
  end
  
  def preprocess_prog
    Intersect.new(@e1.preprocess_prog, @e2.preprocess_prog)
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
  
  def eval_prog env
    v1 = @e1.eval_prog(env)
    new_env = env + [[@s, v1]]
    @e2.eval_prog(new_env)
  end
  
  def preprocess_prog
    Let.new(@s, @e1.preprocess_prog, @e2.preprocess_prog)
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
    self # variables don't need preprocessing
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
  
  def eval_prog env
    v = @e.eval_prog(env)
    v.shift(@dx, @dy)
  end
  
  def preprocess_prog
    Shift.new(@dx, @dy, @e.preprocess_prog)
  end
end
