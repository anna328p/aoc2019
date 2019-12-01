#!/usr/bin/ruby

# AoC 2019 Day 1 (cleaned up)


sum = 0

puts File.readlines('input.txt').map { |n| n.to_i / 3 - 2 }.sum
