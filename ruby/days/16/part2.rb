#!/usr/bin/ruby

# Advent of Code 2019 - Day 16 - Part 2

input = File.read(ARGV[0] || 'input.txt').chomp.chars.map(&:to_i)
offset = input[0..7].map

def phase(input)
  input.map.with_index do |val, idx|
    input.map.with_index { |x, elem|
      val = (elem + 1) / (idx + 1) % 4
      x * (val == 1 ? 1 : val == 3 ? -1 : 0)
    }.sum.abs % 10
  end
end

out = phase input
99.times do
  out = phase out
end

puts out[0..7].join
