##
# Library for Intcode parsing and execution.

##
# Defines the state of the Intcode computer.

class State
  attr_accessor :memory, :ip, :halted, :mode, :rel_base
  attr_reader :max_arity, :mem_scale

  ##
  # Initializes the Intcode computer based on a memory image.

  def initialize(rom)
    @memory = rom.dup
    @ip = 0
    @rel_base = 0
    @halted = false
    @mode = []

    @max_arity = $OPCODES.values.map { |ins| ins.arity }.max
    @mem_scale = @memory.size.to_s.size

    # def @memory.[](idx)
    #   self.at(idx) || 0
    # end
  end

  ##
  # Returns the current instruction (pointed at by the IP).

  def curr_ins
    if @memory[@ip]
      @memory[@ip]
    else
      raise RuntimeError, "Instruction is nil"
    end
  end

  ##
  # Returns a number of arguments given a function's arity.

  def get_args(arity)
    (1..arity).map { |pos| memory[ip + pos] }
  end

  ##
  # Formats an instruction for output.

  def format_ins(ins)
    "%#{@mem_scale + 1}s:\t%#{@max_arity + 2}s  %s" % [@ip, ins.code, ins.inspect]
  end

  def next_ins
    begin
      ci = self.curr_ins
    rescue
      raise
    end
    op = $OPCODES[ci % 100]
    return nil if !op

    @mode = Instruction.parse_mode(ci / 100, op.arity)

    args = self.get_args(op.arity)

    return Instruction.new(op, mode, args)
  end

  def cm(pos, arg)
    if @mode[pos] == :position
      return @memory[arg]
    elsif @mode[pos] == :relative
      return @memory[arg + @rel_base]
    else
      return arg
    end
  end

  def addr(pos, arg)
    if @mode[pos] == :position
      return arg
    elsif @mode[pos] == :relative
      return arg + @rel_base
    end
  end

  def run_instruction(ins)
    ins.opcode.run(self, ins.args)
  end
end

class Opcode
  attr_accessor :arity, :name

  def initialize(name, code)
    @name = name
    @code = code
    @arity = code.arity - 1
  end

  def run(state, args)
    res = @code[state, *args]
    state.ip += @arity + 1
    res
  end

  def run2(state, *args)
    @code[state, *args]
    state.ip += @arity + 1
  end

  def to_s
    @name.to_s
  end

  def inspect
    "Opcode(:#{self}, #{@arity}, <code>)"
  end
end

class Instruction
  attr_accessor :opcode, :mode, :args

  @@mode_types = { 0 => :position, 1 => :immediate, 2 => :relative }

  def initialize(opcode, mode, args)
    @opcode = opcode
    @mode = mode
    @args = args
  end

  def self.parse_mode(mode, arity)
    mode.to_s.rjust(arity, ?0).chars.map(&:to_i).reverse.map { |m| @@mode_types[m] }
  end

  def arity
    @opcode.arity
  end

  def code
    c = @mode.reverse.map { |m| @@mode_types.invert[m].to_s }.join
    c + "%02d" % [$OPCODES.invert[@opcode]]
  end

  def inspect
    f_args = args.map.with_index { |a, i|
      case @mode[i]
      when :position
        "[#{a}]"
      when :relative
        "rel(#{a})"
      else
        "#{a}"
      end
    }.join ', '
    return "#{@opcode} #{f_args}"
  end
end


$OPCODES = {
  1  => Opcode.new(:add, -> s, a, b, c {
    s.memory[s.addr(2, c)] = s.cm(0, a) + s.cm(1, b)
  }),
  2  => Opcode.new(:mul, -> s, a, b, c {
    s.memory[s.addr(2, c)] = s.cm(0, a) * s.cm(1, b)
  }),
  3  => Opcode.new(:inp, -> s, a {
    s.memory[s.addr(0, a)] = STDIN.gets.to_i
  }),
  4  => Opcode.new(:out, -> s, a {
    puts s.cm(0, a)
  }),
  5  => Opcode.new(:jit, -> s, a, b {
    if s.cm(0, a) != 0
      s.ip = s.cm(1, b) - 3
    end
  }),
  6  => Opcode.new(:jif, -> s, a, b {
    if s.cm(0, a) == 0
      s.ip = s.cm(1, b) - 3
    end
  }),
  7  => Opcode.new(:tlt, -> s, a, b, c {
    if s.cm(0, a) < s.cm(1, b)
      s.memory[s.addr(2, c)] = 1
    else
      s.memory[s.addr(2, c)] = 0
    end
  }),
  8  => Opcode.new(:teq, -> s, a, b, c {
    if s.cm(0, a) == s.cm(1, b)
      s.memory[s.addr(2, c)] = 1
    else
      s.memory[s.addr(2, c)] = 0
    end
  }),
  9  => Opcode.new(:arb, -> s, a {
    s.rel_base += s.cm(0, a)
  }),
  99 => Opcode.new(:hlt, -> s {
    s.halted = true
  })
}

