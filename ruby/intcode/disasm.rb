#!/usr/bin/env ruby
require 'yaml'

# Intcode Disassembler

require './libintcode'

def disasm(s, addr_map)
  codes = []

  until s.ip > s.memory.size or s.ip > (addr_map['cutoff'] || Float::INFINITY)
    if addr_map.keys.include? s.ip
      codes << ["", ""]
      codes << ["l:#{addr_map[s.ip]}", ""]
    end

    begin
      ins = s.next_ins
      if ins == nil
        s.ip += 1
        next
      end
      # p ins
    rescue RuntimeError => e
      codes << ["# [#{s.ip}]: value #{s.memory[s.ip]}", "#{e.message}"]
      s.ip += 1
      next
    end

    if ins
      op = ins.opcode.name
      useless_arg = nil

      a0 = ins.args[0]
      a1 = ins.args[1]

      case op
      when :add
        if a0 == 0 || a1 == 0
          useless_arg = ins.args.index(0)
          op = :mov
        end
      when :mul
        if a0 == 1 || a1 == 1
          useless_arg = ins.args.index(1)
          op = :mov
        end
      when :jit
        if a0 == 1
          useless_arg = 0
          op = :jmp
        end
      when :jif
        if a0 == 0
          useless_arg = 0
          op = :jmp
        end
      end

      f_args = ins.args.filter_map.with_index { |a, i|
        next if useless_arg == i

        arg = a
        if addr_map[a]
          arg = ":#{addr_map[a]}"
        end

        case ins.mode[i]
        when :position
          if a != arg
            arg
          else
            "[#{a}]"
          end
        when :relative
          "rel(#{a})"
        else
          jumps = [:jit, :jif]
          if jumps.include? ins.opcode.name and i == 1
            a = arg
          end
          "#{a}"
        end
      }.join ', '

      f_ins     = "\t#{op}\t#{f_args}"
      f_comment = "# [#{s.ip}]: #{ins.code} #{ins.args.join(' ')}"

      codes << [f_ins, f_comment]

      s.ip += ins.arity + 1
    end

  end

  return codes
end

rom = File.read(ARGV[0] || 'input.txt').split(',').map(&:to_i)

addr_map = nil
begin
  addr_map = YAML.load File.read(ARGV[1] || 'addr_map.yml')
rescue StandardError
  addr_map = {}
end

state = State.new rom
codes = disasm(state, addr_map)

ml = codes.map { |c| c[0].size }.max
puts codes.map { |c| c[0].ljust(ml, ' ') + "\t\t" + c[1] }
