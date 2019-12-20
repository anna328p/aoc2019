#!/usr/bin/env ruby

# Advent of Code 2019 - Day 17 - Part 1

require './libintcode'



### INTCODE SETUP ###
iq = Queue.new
oq = Queue.new

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
s = State.new(rom, iq, oq)

#main_thread = Thread.new do
until s.halted
  s.run_instruction s.next_ins
end
#end

#main_thread.join

#s.iq.close

program_output = []
while (not s.oq.empty? and inp = s.oq.pop)
  program_output << inp
end
#s.oq.close

str = program_output.map(&:chr).join
ary = str.split(?\n).map { |r| r.chars }

param = 0
intersections = []
ary.map.with_index do |row, y|
  row.each_with_index do |chr, x|
    if ary[y-1] \
        and ary[y+1] \
        and ary[y-1][x] == '#' \
        and ary[y+1][x] == '#' \
        and row[x-1] == '#' \
        and row[x+1] == '#' \
        and chr == '#'
      param += (y) * (x)
      intersections << [x, y]
    end
  end
end

ary.each_with_index do |row, y|
  row.each_with_index do |chr, x|
    if intersections.include? [x, y]
      print '@'
    else
      print chr
    end
  end
    puts
end

puts param

