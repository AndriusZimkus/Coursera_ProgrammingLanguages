class A

  # Class constant
  Global = 9
  
  #constructor
  def initialize(f=0)
    @foo = f
  end
  def m1
    @foo = 0
  end

  def m2 x
    @foo += x
    #Class variable
    @@bar += 1
  end

  def foo
    @foo
  end

  def self.reset_bar
    @@bar = 0
  end

  def bar
    @@bar
  end

end
