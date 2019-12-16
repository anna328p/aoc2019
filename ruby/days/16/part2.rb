#!/usr/bin/ruby

# Advent of Code 2019 - Day 16 - Part 2

input = File.read(ARGV[0] || 'input.txt').chomp.chars.map(&:to_i)

def phase(input)
  input.map.with_index do |val, idx|
    # Generate the pattern
    pattern = [0, 1, 0, -1].flat_map { |item| [item] * (idx + 1) }.cycle.take(input.size + 1).drop(1)
    pattern.zip(input).map { |i| i[0] * i[1] }.sum.abs % 10
  end
end

out = phase input
99.times do
  out = phase out
end

puts out[0..7].join
