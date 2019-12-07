#!/usr/bin/env ruby

# Intcode Interpreter

require './libintcode'
$INSTRUCTIONS[:inp] = Instruction.new(:inp, 1, -> s, a, b {
  s.memory[a] = b
})
$INSTRUCTIONS[:out] = Instruction.new(:out, 1, -> s, a {
  cm(s, 0, a)
})

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

def interpret(rom, input)
  s = State.new(rom)

  s.ip = 0
  ins = s.memory[0]

  out = []

  if $VERBOSE
    max_arity = $INSTRUCTIONS.map { |name, ins| ins.arity }.max
    mem_scale = s.memory.size.to_s.length
  end

  until s.halted
    cur_res = ""
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
    tok = $TOKENS[ci]
    ins = $INSTRUCTIONS[tok]

    if $VERBOSE
      f_ip = s.ip.to_s.rjust(mem_scale + 1, ' ')
      STDERR.print "#{f_ip}:\t"
    end

    begin
      s.mode = parse_mode(s.curr_ins / 100, ins.arity)
      args = s.get_args(ins.arity)
    rescue NoMethodError
      STDERR.puts
      STDERR.puts " ===== ERROR ====="
      STDERR.puts "Method not found: #{s.memory[s.ip]}"
      STDERR.puts
      if $VERBOSE
        s.memory[0..100].each.with_index do |val, idx|
          STDERR.puts "\t#{idx}:\t#{val}"
        end
      end
      exit
    end

    if $VERBOSE
      f_curr_ins = s.curr_ins.to_s \
        .rjust(ins.arity + 2, ?0) \
        .rjust(max_arity + 2, ' ')
      f_args = args.map.with_index { |a, i|
        s.mode[i] == :position ? "##{a}" : "$#{a}"
      }.join ', '
      STDERR.print "#{f_curr_ins}  #{ins} #{f_args} "
    end

    if tok == :out
      out << (cur_res = ins.run(s, args))
    elsif tok == :inp
      cur_res = ins.run2(s, *args, input.shift)
    else
      cur_res = ins.run(s, args)
    end

    if $VERBOSE
      STDERR.puts "=> #{cur_res}"
    end
  end

  return out
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)

p [*0..4].permutation(5).map { |c|
  res1 = interpret(rom, [c[0], 0])[0]
  res2 = interpret(rom, [c[1], res1])[0]
  res3 = interpret(rom, [c[2], res2])[0]
  res4 = interpret(rom, [c[3], res3])[0]
  interpret(rom, [c[4], res4])[0]
}.max
