# Procs

a = [3,5,7,9]
b = a.map {|x| x+1}

#puts b

i = b.count {|x| x>=6}
puts i

c = a.map {|x| (lambda {|y| x >= y}) }
puts c

d = c[2].call 4
puts d

e = c.count {|x| x.call(4)}

puts e

# Hashes and Ranges
puts "___"
puts "Hashes and Ranges"

h1 = {} # Hash.new
puts h1

h1["a"] = "Found A"
h1[false] = "Found false"
puts h1

puts h1.keys
puts h1.values

h2 = {"SML"=>1, "Racket"=>2, "Ruby"=>3}

h2.each {|k,v| print k; print ": "; puts v}

#Ranges - more efficient than array
puts 1..1000

puts (1..100).inject {|acc,x| acc+x}

#Use ranges when you can
#Use hashes when non-numeric keys better represent data

def foo a
  a.count {|x| x*x < 50}
end

print "array: "; puts foo [3,5,7,9]
print "range: "; puts foo (3..9)
