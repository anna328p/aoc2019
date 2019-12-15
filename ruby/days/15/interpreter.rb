#!/usr/bin/env ruby

# Intcode Interpreter

require './libintcode'

def run(s)
  until s.halted
    ins = s.next_ins

    if $VERBOSE
      STDERR.print s.format_ins(ins)
      STDERR.puts " \t# => #{s.run_instruction(ins)}"
    else
      s.run_instruction(ins)
    end

  end

  return s.memory
end


iq = Queue.new
oq = Queue.new

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
s = State.new(rom, iq, oq)

in_thread = Thread.new { while (str = gets); s.iq << str.to_i; end }
out_thread = Thread.new { until s.oq.closed?; puts s.oq.pop; end }

main_thread = Thread.new { run(s) }





main_thread.join

s.oq.close
