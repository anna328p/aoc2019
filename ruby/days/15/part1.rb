#!/usr/bin/env ruby
require 'set'

# Advent of Code 2019 Day 15 Part 1

require './libintcode'
require './direction'
require './traversal'
require './pathfinding'

### INTCODE SETUP ###
iq = Queue.new
oq = Queue.new

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
s = State.new(rom, iq, oq)

main_thread = Thread.new do
  until s.halted
    s.run_instruction s.next_ins
  end
end

### TRAVERSAL ###
coords, points = nil, nil
if File.exist? 'p1_memo'
  f = Marshal.load(File.read 'p1_memo')
  coords, points = f
else
  coords, points = traverse(s)
  points[[0, 0]] = :empty
  File.write 'p1_memo', Marshal.dump([coords, points])
end

$points = points

s.oq.close
15.times do
  s.iq << 0
end

main_thread.join

puts "Done traversing."
p coords

### PATHFINDING ###
res = a_star([0, 0], coords, points: points) { |n| ($points[n] == :wall || $points[n] == nil) ? 9999999999 : 1 }

### OUTPUT ###
puts "final path: #{res}"
puts "size: #{res.size - 1}"
