class Direction
  attr_accessor :curr

  @@dirs = [:up, :down, :left, :right]
  def initialize(first)
    @curr = first
  end

  def cw
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
  def ccw
    3.times { cw }
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

  def to_i
    @@dirs.find_index(@curr) + 1
  end

  def inspect
    "Direction #{@curr}"
  end
end

