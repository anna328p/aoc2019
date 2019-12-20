#!/usr/bin/env ruby

# Advent of Code 2019 - Day 19 - Part 1

require './libintcode'

def scan(rom, x, y)
  iq = Queue.new
  oq = Queue.new

  iq << x
  iq << y

  s = State.new(rom.dup, iq, oq)

  until s.halted
    ins = s.next_ins
    s.run_instruction ins
  end

  until oq.empty?
    return oq.pop
  end
end


rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)

a = []
count = 0

50.times do |y|
  row = []
  50.times do |x|
    cell = scan(rom, x, y)
    count += cell
    row << cell
  end
  a << row
end

if $VERBOSE
  puts a.map { |r| r.map { |ch| ch == 1 ? '#' : '.' }.join ' ' }.join ?\n
end
puts count
