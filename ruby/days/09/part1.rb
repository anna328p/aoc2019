#!/usr/bin/env ruby

# Intcode Interpreter

require './libintcode'

def run(s)
  until s.halted
    ins = s.next_ins

    if $VERBOSE
      STDERR.puts s.format_ins(ins)
    end

    s.run_instruction(ins)
  end

  return s.memory
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
s = State.new(rom)
run(s)
