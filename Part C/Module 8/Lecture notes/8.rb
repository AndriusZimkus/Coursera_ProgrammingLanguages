# Using blocks
# yield - is a block

def silly a
  (yield a) + (yield 42)
end

puts silly(5) {|b| b*2}

class Foo
  def initialize (max)
    @max = max
  end
  def silly
    yield(4,5) + yield(@max,@max)
  end

  def count base
    if base > @max
      raise "reached max"
    elsif yield base
      1
    else
      1 + (count(base+1) {|i| yield i})
    end
  end
end

f = Foo.new (1000)
puts f.silly {|a,b| 2*a - b}

puts f.count(10) {|i| (i*i) == (500*i) }
