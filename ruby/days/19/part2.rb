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

def expand(rom, arr)
  height = arr.size
  if height == 0
    return [[scan(rom, 0, 0)]]
  end

  a = arr.dup
  width = a[0].size

  a.each_with_index do |row, y|
    row << scan(rom, width, y)
  end

  if a[-1][-1] != 1 and a[-2] and a[-2][-1] == 1
    return a
  end

  row = []
  (width + 1).times do |x|
    cell = scan(rom, x, height)
    row << cell
  end
  a << row

  return a
end

find_size = 100

loop do
  a = expand rom, a
  if $VERBOSE
    puts a.map { |r| r.map { |ch| ch == 1 ? '#' : '.' }.join ' ' }.join ?\n
  end

  first_row = a.find_index { |r| r[-1] == 1 } || 0
  last_row = a.find_index.with_index { |row, idx|
    idx > first_row && row[-1 - (idx - first_row)] == 0
  } || 0

  max_square = last_row - first_row
  if $VERBOSE
    puts max_square
  end
  if max_square == find_size
    puts first_row + (a[first_row].size - find_size) * 10000
    break
  end
end

