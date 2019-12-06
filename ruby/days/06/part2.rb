#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dijkstra'

# Advent of Code 2019 - Day 6 - Part 1

input = File.readlines(ARGV[0] || 'input.txt').map { |m| m.chomp.split(')') }

graph = RGL::AdjacencyGraph.new

input.each { |i| graph.add_edge(*i) }

puts graph.dijkstra_shortest_path(Hash.new(0), 'SAN', 'YOU').size - 3
