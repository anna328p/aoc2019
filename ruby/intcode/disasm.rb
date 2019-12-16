#!/usr/bin/env ruby
require 'yaml'

# Intcode Disassembler

require './libintcode'

def disasm(s, addr_map)
  codes = []

  until s.ip > s.memory.size or s.ip > (addr_map['cutoff'] || Float::INFINITY)
    if addr_map.keys.include? s.ip
      codes << ["# label #{addr_map[s.ip]}", ""]
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
      f_args = ins.args.map.with_index { |a, i|
        case ins.mode[i]
        when :position
          a = addr_map[a] || a
          "[#{a}]"
        when :relative
          "rel(#{a})"
        else
          jumps = [:jit, :jif]
          if jumps.include? ins.opcode.name and i == 1
            a = addr_map[a] || a
          end
          "#{a}"
        end
      }.join ', '
      f_ins = "#{ins.opcode} #{f_args}"
      codes << [f_ins, "# [#{s.ip}]: #{ins.code} #{ins.args.join(' ')}"]
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
