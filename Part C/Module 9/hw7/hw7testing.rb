require "./hw7d.rb"

#Constants for testing
ZERO = 0.0
ONE = 1.0
TWO = 2.0
THREE = 3.0
FOUR = 4.0
FIVE = 5.0
SIX = 6.0
SEVEN = 7.0
TEN = 10.0

a = Point.new(1,5)
puts "Printing point a - #{a}"

b = LineSegment.new(1,2,1,2)
puts "Printing line segment b - #{b}"
c = b.preprocess_prog
puts "C is preprocessed B - should be point - #{c} C coordinates - x #{c.x} y #{c.y}"

d = LineSegment.new(10,5,2,4)
e = d.preprocess_prog
puts "E - #{e} #{e.x1} #{e.y1} #{e.x2} #{e.y2}"

f = e.eval_prog []
puts f


g = Shift.new(5,8,a)
h = g.eval_prog []
puts "h #{h.x} #{h.y}"

i = [["A",2,3]]
j = i + [[4,5]]
puts j.first

puts "last test"
l2 = Let.new("a", LineSegment.new(-ONE, -TWO, THREE, FOUR),
             Let.new("b", LineSegment.new(THREE,FOUR,-ONE,-TWO), Intersect.new(Var.new("a"),Var.new("b"))))
puts l2
l2 = l2.preprocess_prog.eval_prog([["a",Point.new(0,0)]])
puts "Should be line segment"

puts l2
