#!/usr/bin/env ruby

require 'set'

# Advent of Code Day 3 Part 2

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
  steps = 0

  map = Hash.new
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
      map[c.dup] = steps if !map[c.dup]
      steps += 1
      c[0] += change[0]
      c[1] += change[1]
    end
  end
  return map
end

trace1 = trace(line1)
trace2 = trace(line2)

intersections = trace2.keep_if { |k, v| trace1.has_key?(k) }.keys - [[0, 0]]

min_int = intersections.min_by { |p| trace1[p] + trace2[p] }
p trace1[min_int] + trace2[min_int]
