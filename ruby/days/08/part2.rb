#!/usr/bin/env ruby

# Advent of Code 2019 - Day 8 - Part 1

width = 25
height = 6

layers = File.read('input.txt').scan(/.{#{width * height}}/).map { |l| l.chars.map(&:to_i)}

f = Array.new(width * height, 2)
layers.each do |l|
  l.each.with_index do |px, i|
    if f[i] == 2
      f[i] = l[i]
    end
  end
end

f.each_slice(width) do |l|
  puts l.join.gsub(?0, ' ')
end
