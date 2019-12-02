#!/usr/bin/env ruby

# Intcode Interpreter

class State
  attr_accessor :memory, :ip, :halted
  def initialize(rom)
    @memory = rom.dup
    @ip = 0
    @halted = false
  end

  def curr_ins
    return @memory[@ip]
  end
  def get_args(n)
    (1..n).map { |loc| memory[ip + loc] }
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
  99 => :hlt
}

$INSTRUCTIONS = {
  add: Instruction.new(:add, 3, -> s, a, b, c {
    s.memory[c] = s.memory[a] + s.memory[b]
  }),
  mul: Instruction.new(:mul, 3, -> s, a, b, c {
    s.memory[c] = s.memory[a] * s.memory[b]
  }),
  hlt: Instruction.new(:hlt, 0, -> s {
    s.halted = true
  })
}

def interpret(rom, noun, verb)
  s = State.new(rom)

  s.memory[1] = noun
  s.memory[2] = verb

  s.ip = 0
  ins = s.memory[0]

  until s.halted
    ins = $INSTRUCTIONS[$TOKENS[s.curr_ins]]
    args = s.get_args(ins.arity)
    puts "#{ins}\t#{args.join ?\t}"
    ins.run(s, args)
  end

  return s.memory
end

rom = File.read('input.txt').split(',').map(&:to_i)

0.upto(99) do |noun|
  0.upto(99) do |verb|
    memory = interpret(rom, noun, verb)

    puts " => #{memory[0]}"
    if memory[0] == 19690720
      puts "Noun #{noun}, verb #{verb}"
      puts "Value: #{100 * noun + verb}"
      exit
    end
  end
end

