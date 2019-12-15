#!/usr/bin/env ruby

# Advent of Code 2019 - Day 10 - Part 1

input = File.readlines('input.txt').map(&:chars)

asteroids = input.flat_map.with_index { |r, idx| r.map.with_index {|c, idx| c == '#' ? idx : nil}.compact.map { |f| [idx, f] } }

p asteroids.map { |a|
  asteroids.map { |b| [Math.atan2(b[1] - a[1], b[0] - a[0]), b] }.uniq { |a| a[0] }
}.max_by { |a| a.size }.size
