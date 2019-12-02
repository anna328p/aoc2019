#!/usr/bin/env ruby

# Advent of Code 2019 - Day 2

codes = File.read('input.txt').split(',').map(&:to_i)

codes[1] = 12
codes[2] = 2

pos = 0
cur_code = codes[0]

loop do
  cur_code = codes[pos]
  inp1 = codes[pos + 1] || nil
  inp2 = codes[pos + 2] || nil
  inp3 = codes[pos + 3] || nil
  case cur_code
  when 1
    codes[inp3] = codes[inp1] + codes[inp2]
    pos += 4
  when 2
    codes[inp3] = codes[inp1] * codes[inp2]
    pos += 4
  when 99
    break
  end
end

puts codes[0]
