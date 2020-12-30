#!/usr/bin/env ruby

# Advent of Code 2019 - Day 18 - Part 1

require './pathfinding'

tiles = {
  :wall => /#/,
  :empty => /\./,
  :entrance => /@/,
  :key => /[a-z]/,
  :door => /[A-Z]/,
  :invalid => /./
}

input = File.readlines(ARGV[0] || 'input.txt').map { |l|
  l.chomp.chars.map { |c|
    [tiles.find { |k, v| v.match? c }[0], c]
  }
}

points = {}
input.each.with_index { |row, y|
  row.each.with_index { |tile, x|
    points[[x, y]] = tile
  }
}

owned_keys = []

start = points.find { |k, v| v[0] == :entrance }[0]
key = points.find { |k, v| v[0] == :key }[0]
p points
res = a_star(start, key, input: input, tiles: tiles) { |coords|
  inf = 10**10
  p coords
  n = points[coords] || [:invalid]
  puts n[0]
  puts owned_keys
  case n[0]
  when :wall
    inf
  when :empty
    1
  when :entrance
    1
  when :key
    1
  when :door
    if owned_keys.include? n[1]
      p :included
      1
    else
      inf
    end
  when :invalid
    inf
  else
    1
  end
}
p res
