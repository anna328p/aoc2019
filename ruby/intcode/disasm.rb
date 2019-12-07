#!/usr/bin/env ruby

# Intcode Disassembler

require './libintcode'

class State
  attr_accessor :memory, :ip, :halted, :mode
  def initialize(rom)
    @memory = rom.dup
    @ip = 0
    @halted = false
    @mode = []
  end

  def curr_ins
    return @memory[@ip]
  end

  def get_args(arity)
    (1..arity).map { |pos| memory[ip + pos] }
  end
end

def disasm(rom)
  s = State.new(rom)
  codes = []

  s.ip = 0
  ins = s.memory[0]

  until s.curr_ins == nil
    ci = s.curr_ins % 100
    tok = $TOKENS[ci]
    ins = $INSTRUCTIONS[tok]

    if ins == nil
      codes << ["# [#{s.ip}]: value #{s.curr_ins}", ""]
      s.ip += 1
      next
    end

    s.mode = parse_mode(s.curr_ins / 100, ins.arity)

    args = s.get_args(ins.arity)

    f_args = args.map.with_index { |a, i|
      s.mode[i] == :position ? "[#{a}]" : "#{a}"
    }.join ', '
    codes << ["#{ins} #{f_args}", "# [#{s.ip}]: #{ci} #{args.join(' ')}"]

    s.ip += ins.arity + 1
  end

  return codes
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
codes = disasm(rom)
ml = codes.map { |c| c[0].size }.max
puts codes.map { |c| c[0].ljust(ml, ' ') + "\t\t" + c[1] }
