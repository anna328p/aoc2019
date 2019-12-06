#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/traversal'

# Advent of Code 2019 - Day 6 - Part 1

input = File.readlines(ARGV[0] || 'input.txt').map { |m| m.chomp.split ')' }

graph = RGL::DirectedAdjacencyGraph.new

input.each do |n|
  graph.add_edge(*n)
end

p graph.vertices.map { |v| graph.bfs_iterator(v).to_a.size - 1 }.sum
