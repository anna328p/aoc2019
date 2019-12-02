#!/usr/bin/env ruby

# Intcode Interpreter

class State
  property :memory, :ip, :halted
  @memory : Array(Int32)

  def initialize(rom : Array(Int32))
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
  property :arity, :name

  @name : Symbol
  @arity : Int32
  @code : (State, Array(Int32)) -> Nil

  def initialize(name, arity, code)
    @name = name
    @arity = arity
    @code = code
  end

  def run(state, args)
	@code.call(state, args)
    state.ip += arity + 1
  end

  def to_s
    @name.to_s
  end

  def inspect
    "Instruction(:#{self}, #{@arity}, <code>)"
  end
end

TOKENS = {
  1  => :add,
  2  => :mul,
  99 => :hlt
}

INSTRUCTIONS = {
  add: Instruction.new(:add, 3, -> (s : State, args : Array(Int32)) {
    s.memory[args[2]] = s.memory[args[0]] + s.memory[args[1]]
  }),
  mul: Instruction.new(:mul, 3, -> (s : State, args : Array(Int32)) {
    s.memory[args[2]] = s.memory[args[0]] * s.memory[args[1]]
  }),
  hlt: Instruction.new(:hlt, 0, -> (s : State, args : Array(Int32)) {
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
    ins = INSTRUCTIONS[TOKENS[s.curr_ins]]
    args = s.get_args(ins.arity)
	# puts "#{ins.to_s}\t#{args.join '\t'}"
    ins.run(s, args)
  end

  return s.memory
end

rom : Array(Int32) = File.read("input.txt").split(',').map { |i| i.to_i }

0.upto(99) do |noun|
  0.upto(99) do |verb|
    memory = interpret(rom, noun, verb)

    # puts " => #{memory[0]}"
    if memory[0] == 19690720
      puts "Noun #{noun}, verb #{verb}"
      puts "Value: #{100 * noun + verb}"
      exit
    end
  end
end

