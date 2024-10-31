# Duck typing
load "MyRational.rb"

# Arrays
a = [3,2,7,9]

puts a[0]
puts a.size
 
a[1] = 6

a[5] = 78

puts a

b = a + [true, false]

# or - union
c = [1,2,3] | [3,2,3,4]
z = Array.new (5) { 0 }

# using array as a stack
a.push 5
a.pop

# using array as a queue
a.shift
a.push 4

a.unshift 19
a.shift

a2 = a
a3 = a + []

f = [2,4,6,8,10,12,14]
f[2,4]
f[2,4] = [1,1]

[1,3,4,12].each {|x| puts (x*x)}
