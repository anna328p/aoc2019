def show input, tiles, all_pos, **kwargs
  a = input.map { |row|
    row.map { |tile| tile[1] }
  }

  all_pos.each do |pos|
    if a[pos[1]]
      a[pos[1]][pos[0]] = '*'
    end
  end

  if kwargs[:dst]
    pos = kwargs[:dst]
    a[pos[1]][pos[0]] = '&'
  end

  puts a.map { |r| r.join '' }
end
