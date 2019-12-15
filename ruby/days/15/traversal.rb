require './direction'

### TRAVERSAL ###

def show m, *all_pos, **kwargs
  # print "\u001B[0;0H"
  k = m.keys
  xmin = k.min_by { |k| k[0] }[0]
  ymin = k.min_by { |k| k[1] }[1]
  xmax = k.max_by { |k| k[0] }[0]
  ymax = k.max_by { |k| k[1] }[1]

  xsize = xmax - xmin + 1
  ysize = ymax - ymin + 1
  a = Array.new(xsize) { Array.new(ysize, '░░') }
  k.each do |t|
    val = nil
    if m[t] == :wall
      val = '██'
    elsif m[t] == :empty
      val = '  '
    else
      val = 'EE'
    end
    a[t[0] - xmin][t[1] - ymin] = val
  end
  all_pos.each do |pos|
    a[pos[0] - xmin][pos[1] - ymin] = '▓▓'
  end

  if kwargs[:src]
    pos = kwargs[:src]
    a[pos[0] - xmin][pos[1] - ymin] = '**'
  end

  if kwargs[:dst]
    pos = kwargs[:dst]
    a[pos[0] - xmin][pos[1] - ymin] = '##'
  end

  puts a.map { |r| r.join '' }
end

def traverse s
  def s.go dir
    @iq << dir.to_i
  end
  def s.look
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

  d = Direction.new :up
  points[[0, 0]] = :empty

  loop do
    if $VERBOSE == true
      print "\u001B[0;0H"
    end
    s.go d
    l = s.look
    if l == 0
      points[pos.with d.coords] = :wall
      d = Direction.new([:up, :down, :left, :right].reject {
        |h| points[pos.with (Direction.new h).coords]
      }.sample || ([:up, :down, :left, :right].sample))
    elsif l == 1
      pos.move d.coords
      d = Direction.new([:up, :down, :left, :right].reject {
        |h| points[pos.with (Direction.new h).coords]
      }.sample || ([:up, :down, :left, :right].sample))
      points[pos.dup] = :empty
    elsif l == 2
      points[pos.with d.coords] = :oxygen
      s.halted = true
      p = pos.with(d.coords)
      return [p[0], p[1]], points
    end
    if $VERBOSE == true
      show points, pos
    end
  end
end
