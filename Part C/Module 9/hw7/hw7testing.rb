require "./hw7.rb"

a = Point.new(1,5)
puts a

b = LineSegment.new(1,2,1,2)
puts b
c = b.preprocess_prog
puts "C - #{c} #{c.x} #{c.y}"

d = LineSegment.new(10,5,2,4)
e = d.preprocess_prog
puts "E - #{e} #{e.x1} #{e.y1} #{e.x2} #{e.y2}"

f = e.eval_prog []
puts f
