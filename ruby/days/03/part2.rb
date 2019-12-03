#!/usr/bin/env ruby

require 'set'

# Advent of Code Day 3 Part 1

line1, line2 = *(File.readlines('input.txt').map { |l|
  l.split(',').map { |loc|
    [
      {
        ?U => :up,
        ?D => :down,
        ?L => :left,
        ?R => :right
      }[loc[0]],
      loc[1..-1].to_i
    ]
  }
})

def trace(line)
  c = [0, 0]

  set = Set.new
  line.each do |i|
    dist = i[1]
    d = c.dup
    change = [0, 0]

    case i[0]
    when :up
      change = [0, 1]
      d[1] += dist
    when :down
      change = [0, -1]
      d[1] -= dist
    when :left
      change = [-1, 0]
      d[0] -= dist
    when :right
      change = [1, 0]
      d[0] += dist
    end

    until c[0] == d[0] && c[1] == d[1]
      set.add c.dup
      c[0] += change[0]
      c[1] += change[1]
    end
  end
  return set
end

trace_1 = trace(line1)
trace_2 = trace(line2)

intersections = trace_1 & trace_2 - Set[[0, 0]]

puts intersections.min_by { |a| a[0].abs + a[1].abs }.sum
