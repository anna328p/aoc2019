#!/usr/bin/env ruby

# Advent of Code - Day 5 - Part 1

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

class Instruction
  attr_accessor :arity, :name

  def initialize(name, arity, code)
    @name = name
    @arity = arity
    @code = code
  end

  def run(state, args)
    @code[state, *args]
    state.ip += arity + 1
  end

  def to_s
    @name.to_s
  end

  def inspect
    "Instruction(:#{self}, #{@arity}, <code>)"
  end
end

$TOKENS = {
  1  => :add,
  2  => :mul,
  3  => :inp,
  4  => :out,
  99 => :hlt
}

def cm(state, pos, arg)
  if state.mode[pos] == :position
    return state.memory[arg]
  else
    return arg
  end
end


$INSTRUCTIONS = {
  add: Instruction.new(:add, 3, -> s, a, b, c {
    s.memory[c] = cm(s, 0, a) + cm(s, 1, b)
  }),
  mul: Instruction.new(:mul, 3, -> s, a, b, c {
    s.memory[c] = cm(s, 0, a) * cm(s, 1, b)
  }),
  inp: Instruction.new(:inp, 1, -> s, a {
    s.memory[a] = gets.to_i
  }),
  out: Instruction.new(:out, 1, -> s, a {
    puts cm(s, 0, a)
  }),
  hlt: Instruction.new(:hlt, 0, -> s {
    s.halted = true
  })
}

def parse_mode(mode, arity)
    mode_types = { 0 => :position, 1 => :immediate }
    mode.to_s.rjust(arity, ?0).chars.map(&:to_i).reverse.map { |m| mode_types[m] }
end

def interpret(rom)
  s = State.new(rom)

  s.ip = 0
  ins = s.memory[0]

  until s.halted
    ci = s.curr_ins % 100
    ins = $INSTRUCTIONS[$TOKENS[ci]]

    s.mode = parse_mode(s.curr_ins / 100, ins.arity)

    args = s.get_args(ins.arity)
    STDERR.puts "#{ins}\t#{args.join ?\t}"
    ins.run(s, args)
  end

  return s.memory
end

rom = File.read('input.txt').split(',').map(&:to_i)
interpret(rom)
