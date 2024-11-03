# Subclassing

class Point
  attr_accessor :x, :y # defines methods x, y, x=, y=

  def initialize (x,y)
    @x = x
    @y = y
  end
  def distFromOrigin
    Math.sqrt(@x *@x + @y*@y) # uses instance variables
  end
  def distFromOrigin2
    Math.sqrt(x*x + y*y) # uses getter methods
  end

end

class ColorPoint < Point
  attr_accessor :color

  def initialize (x,y,c="clear")
    super(x,y) #keyword super calls same method in superclass
    @color =c
  end
end

cp = ColorPoint.new(1,2,"black")
puts cp
puts cp.x
puts cp.y
puts cp.color

cp2 = ColorPoint.new(4,21)
puts cp2.color

cp3 = Point.new(0,0)
cp4 = ColorPoint.new(0,0,"red")
puts cp3.class
puts cp4.class

puts cp4.class.superclass

puts cp3.is_a? Point
puts cp4.is_a? Point
puts cp4.is_a? ColorPoint
puts cp.instance_of? Point
