#!/usr/bin/env ruby

# Advent of Code 2019 - Day 4 - Part 2

min, max = File.read('input.txt').chomp.split('-').map(&:to_i)

passwords = []

(min..max).each do |i|
  str = i.to_s
  if str.to_enum(:scan, /(\d)\1+/).map {
      Regexp.last_match.to_a.filter { |a| a.size == 2 }
  }.flatten != [] and str.chars.sort.join == str
    passwords << str
  end
end

p passwords.size
