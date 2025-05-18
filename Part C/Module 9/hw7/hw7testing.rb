require "./hw7.rb"

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
