class Direction
  attr_accessor :curr

  @@dirs = [:up, :down, :left, :right]
  def initialize(first = :up)
    @curr = first
  end
  def self.random
    return self.new @@dirs.sample
  end
  def self.random_except &block
    d = @@dirs.reject(&block).sample
    return self.new d if d
    return nil
  end

  def cw!
    if @curr == :up
      @curr = :right
    elsif @curr == :right
      @curr = :down
    elsif @curr == :down
      @curr = :left
    elsif @curr == :left
      @curr = :up
    end
  end
  def rev
    2.times { cw! }
  end
  def ccw!
    3.times { cw! }
  end

  def cw
    dir = @curr
    if dir == :up
      dir = :right
    elsif dir == :right
      dir = :down
    elsif dir == :down
      dir = :left
    elsif dir == :left
      dir = :up
    end
    return Direction.new(dir)
  end
  def rev!
    self.cw.cw
  end
  def ccw
    self.cw.cw.cw
  end

  def coords
    if @curr == :up
      return [0, 1]
    elsif @curr == :down
      return [0, -1]
    elsif @curr == :left
      return [-1, 0]
    elsif @curr == :right
      return [1, 0]
    end
  end

  def to_a
    self.coords
  end
  def [](a)
    self.coords[a]
  end

  def to_i
    @@dirs.find_index(@curr) + 1
  end

  def inspect
    "Direction #{@curr}"
  end
end

