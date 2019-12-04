#!/usr/bin/env ruby

# Advent of Code 2019 - Day 4 - Part 1

min, max = File.read('input.txt').chomp.split('-').map(&:to_i)

passwords = []

(min..max).each do |i|
  str = i.to_s
  if str.match(/(\d)\1/) and str.chars.sort.join == str
    passwords << str
  end
end

p passwords.size
