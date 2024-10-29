class V
  # by default methods public

  def initialize (f=0)
    @foo = f
  end
  

  def foo
    @foo
  end

  def foo= x
    @foo = x
  end

  #getter shorthand
  attr_reader :bar

  #getter-setter shorthand
  attr_accessor :baz

  protected

  public

  private
  
end

a = V.new(5)
puts a.foo
a.foo = 10
puts a.foo
a.baz = 50
puts a.baz
