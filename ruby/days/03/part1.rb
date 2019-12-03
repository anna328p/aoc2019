#!/usr/bin/env ruby

require 'matrix'

# Advent of Code Day 3 Part 1

line1, line2 = *(File.readlines('input.txt').map { |l| l.split(',').map { |loc| [ { ?U => :up, ?D => :down, ?L => :left, ?R => :right }[loc[0]], loc[1..-1].to_i ] } })

def get_length(val, minus, plus)
  case val[0]
  when plus
    val[1]
  when minus
    -val[1]
  else
    0
  end
end

size_x = line1.map { |e| get_length(e, :left, :right) }.sum
size_x += line2.map { |e| get_length(e, :left, :right) }.sum
size_y = line1.map { |e| get_length(e, :down, :up) }.sum
size_y += line2.map { |e| get_length(e, :down, :up) }.sum

p size_x
p size_y

map = Array.new[size_x, size_y]

c = [0, 0]
points1 = line1.map { |i|
  dist = i[1]
  case i[0]
  when :up
    c[1] += dist
  when :down
    c[1] -= dist
  when :left
    c[0] -= dist
  when :right
    c[0] += dist
  end
  [c[0], c[1]]
}

p points1.max_by {|p| p[0]}
p points1.max_by {|p| p[1]}

c = [0, 0]
points2 = line2.map { |i|
  dist = i[1]
  case i[0]
  when :up
    c[1] += dist
  when :down
    c[1] -= dist
  when :left
    c[0] -= dist
  when :right
    c[0] += dist
  end
  [c[0], c[1]]
}

p points2.max_by {|p| p[0]}
p points2.max_by {|p| p[1]}
