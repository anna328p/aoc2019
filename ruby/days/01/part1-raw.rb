#!/usr/bin/ruby

# AoC 2019 Day 1

f = File.read 'input.txt'

sum = 0

f.lines.each do |l|
  sum += l.to_i / 3 - 2
end

puts sum
