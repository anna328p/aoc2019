#!/usr/bin/env ruby

# Intcode Disassembler

require './libintcode'

def disasm(s)
  codes = []

  until s.ip > s.memory.size

    begin
      ins = s.next_ins
      p ins
    rescue RuntimeError => e
      codes << ["# [#{s.ip}]: value #{s.curr_ins}", "#{e.message}"]
      s.ip += 1
      next
    end

    codes << [ins.inspect, "# [#{s.ip}]: #{ins.code} #{ins.args.join(' ')}"]

    s.ip += ins.arity + 1
  end

  return codes
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
state = State.new rom
codes = disasm(state)
ml = codes.map { |c| c[0].size }.max
puts codes.map { |c| c[0].ljust(ml, ' ') + "\t\t" + c[1] }
