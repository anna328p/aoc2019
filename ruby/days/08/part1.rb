#!/usr/bin/env ruby

# Advent of Code 2019 - Day 8 - Part 1

width = 25
height = 6

input = File.read('input.txt').scan /.{#{width * height}}/

correct_line = input.min_by { |i| i.count '0' }

p correct_line.count('1') * correct_line.count('2')
