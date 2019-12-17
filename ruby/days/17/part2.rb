#!/usr/bin/env ruby

# Advent of Code 2019 - Day 17 - Part 1

require './libintcode'



### INTCODE SETUP ###
iq = Queue.new
oq = Queue.new

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
s = State.new(rom, iq, oq)

until s.halted
  s.run_instruction s.next_ins
end
#s.iq.close

program_output = []
while (not s.oq.empty? and inp = s.oq.pop)
  program_output << inp
end
#s.oq.close

str = program_output.map(&:chr).join
ary = str.split(?\n).map { |r| r.chars }

#puts str

def send(q, v)
  if v.class == Integer
    q << v
  elsif v.class == String
    v.chars.each { |c| q << c.ord }
  end
end

def put(q, v)
  send(q, v)
  send(q, 10)
end


iq = Queue.new
oq = Queue.new

put iq, "A,B,A,B,C,C,B,A,B,C"
put iq, "L,8,R,12,R,12,R,10"
put iq, "R,10,R,12,R,10"
put iq, "L,10,R,10,L,6"
put iq, "y"

out_thread = Thread.new do
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
rom[0] = 2
s = State.new(rom, iq, oq)

main_thread = Thread.new do
  until s.halted
    s.run_instruction s.next_ins
  end
end

loop do
  c = s.oq.pop
  if c < 255
    print c.chr
  else
    puts c
  end
end

main_thread.join
