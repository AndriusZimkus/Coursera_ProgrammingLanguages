x = if not nil and not false then 5 else 3 end
puts x

#puts x.methods
#puts 3.methods - nil.methods

#Load My_rational
load "MyRational.rb"

x = MyRational.new(9,6)
puts x.to_s

class MyRational
  def double
    self + self
  end
end

# x also changed
puts x.double.double

puts 3.class

class Fixnum
  def double
    self + self
  end
end

puts 3.double

public
def m
  42
end

puts 0.m
