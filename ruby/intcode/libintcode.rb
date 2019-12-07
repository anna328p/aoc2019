class Instruction
  attr_accessor :arity, :name

  def initialize(name, arity, code)
    @name = name
    @arity = arity
    @code = code
  end

  def run(state, args)
    res = @code[state, *args]
    state.ip += arity + 1
    res
  end

  def run2(state, *args)
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

def cm(state, pos, arg)
  if state.mode[pos] == :position
    return state.memory[arg]
  else
    return arg
  end
end

$TOKENS = {
  1  => :add,
  2  => :mul,
  3  => :inp,
  4  => :out,
  5  => :jit,
  6  => :jif,
  7  => :tlt,
  8  => :teq,
  99 => :hlt
}

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
  jit: Instruction.new(:jit, 2, -> s, a, b {
    if cm(s, 0, a) != 0
      s.ip = cm(s, 1, b) - 3
    end
  }),
  jif: Instruction.new(:jif, 2, -> s, a, b {
    if cm(s, 0, a) == 0
      s.ip = cm(s, 1, b) - 3
    end
  }),
  tlt: Instruction.new(:tlt, 3, -> s, a, b, c {
    if cm(s, 0, a) < cm(s, 1, b)
      s.memory[c] = 1
    else
      s.memory[c] = 0
    end
  }),
  teq: Instruction.new(:teq, 3, -> s, a, b, c {
    if cm(s, 0, a) == cm(s, 1, b)
      s.memory[c] = 1
    else
      s.memory[c] = 0
    end
  }),
  hlt: Instruction.new(:hlt, 0, -> s {
    s.halted = true
  })
}

def parse_mode(mode, arity)
  mode_types = { 0 => :position, 1 => :immediate }
  mode.to_s.rjust(arity, ?0).chars.map(&:to_i).reverse.map { |m| mode_types[m] }
end
