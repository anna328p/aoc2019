require './direction'
require './show'

### TRAVERSAL ###

def traverse s
  def s.go dir
    @iq << dir.to_i
    @oq.pop
  end

  points = {}
  pos = [0, 0]

  def pos.with a
    [
      self[0] + a[0],
      self[1] + a[1]
    ]
  end
  def pos.move a
    self[0] += a[0]
    self[1] += a[1]
  end

  dir = Direction.new
  points[[0, 0]] = :empty

  loop do
    if $VERBOSE == true
      # print "\u001B[0;0H"
    end
    res = s.go dir
    new_pos = pos.with dir
    random_dir = Direction.random_except { |h|
      points[pos.with Direction.new(h)]
    } || Direction.random

    case res
    when 0
      points[new_pos.dup] = :wall
      dir = random_dir
    when 1
      points[pos.dup] = :empty
      pos.move dir
      dir = random_dir
    when 2
      points[new_pos.dup] = :oxygen
      s.halted = true
      return [new_pos[0], new_pos[1]], points
    end

    if $VERBOSE == true
      show points, pos
    end
  end
end
