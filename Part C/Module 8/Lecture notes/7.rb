# Blocks
3.times {puts "hi"}
[4,6,8].each {puts "hi"}
[4,6,8].each {|x| puts x}

i=7
[4,6,8].each {|x| if i > x then puts (x+1) end}

puts "____"
a = Array.new(5) {|i| 4*(i+1)}
puts a

b = a.map {|x| x*2}
puts b

puts a.any? {|x| x > 7}
puts a.any? {|x| x > 700}

puts a.all? {|x| x > 7}
puts a.all? {|x| x > -7}

#only false - false and nil
puts a.all?

#inject = reduce
#(0) - initial accumulator - first element
# in array
puts a.inject(0) {|acc,elt| acc+elt}

#same as map
#a.collect

#filter
puts a.select {|x| x > 7 && x < 18}

def t i
  (0..i).each do |j|
    print " " * j
    (j..i).each {|k| print k; print " "}
    print "\n"
  end
end

t 9

def printArray array
  print "["
  array.each_with_index do |item,index|
    print item.to_s
    if index < array.length - 1
      print ","
    end
  end
  print "]"
end

printArray a
