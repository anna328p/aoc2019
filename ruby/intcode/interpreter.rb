#!/usr/bin/env ruby

# Intcode Interpreter

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

def interpret(rom)
  s = State.new(rom)

  s.ip = 0
  ins = s.memory[0]

  if $VERBOSE
    max_arity = $INSTRUCTIONS.map { |name, ins| ins.arity }.max
    mem_scale = s.memory.size.to_s.length
  end

  until s.halted

    if s.curr_ins == nil
      STDERR.puts
      STDERR.puts " ===== ERROR ====="
      if $VERBOSE
        s.memory.each.with_index do |val, idx|
          STDERR.puts "\t#{idx}:\t#{val}"
        end
      end
      exit
    end

    ci = s.curr_ins % 100
    ins = $INSTRUCTIONS[$TOKENS[ci]]

    s.mode = parse_mode(s.curr_ins / 100, ins.arity)

    args = s.get_args(ins.arity)

    if $VERBOSE
      f_ip = s.ip.to_s.rjust(mem_scale + 1, ' ')
      f_curr_ins = s.curr_ins.to_s \
        .rjust(ins.arity + 2, ?0) \
        .rjust(max_arity + 2, ' ')
      f_args = args.map.with_index { |a, i|
        s.mode[i] == :position ? "##{a}" : "$#{a}"
      }.join ', '
      STDERR.puts "#{f_ip}:\t#{f_curr_ins}  #{ins} #{f_args}"
    end

    ins.run(s, args)
  end

  return s.memory
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)
interpret(rom)
