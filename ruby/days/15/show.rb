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
    if pos
    puts xmin
    puts "#{a.size} #{a[0].size} #{pos[0] - xmin} #{a[pos[0]-xmin]}"
    a[pos[0] - xmin] |= [];
    a[pos[0] - xmin][pos[1] - ymin] = '▓▓'
    end
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
