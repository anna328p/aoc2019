#!/usr/bin/env ruby

# Advent of Code 2019 - Day 2

rom = File.read('input.txt').split(',').map(&:to_i)

0.upto(99) do |noun|
  0.upto(99) do |verb|
    memory = rom.dup

    memory[1] = noun
    memory[2] = verb

    ip = 0
    instruction = memory[0]

    loop do
      instruction = memory[ip]
      arg1 = memory[ip + 1]
      arg2 = memory[ip + 2]
      arg3 = memory[ip + 3]
      if instruction == 1
        memory[arg3] = memory[arg1] + memory[arg2]
        ip += 4
      elsif instruction == 2
        memory[arg3] = memory[arg1] * memory[arg2]
        ip += 4
      elsif instruction == 99
        break
      end
    end

    puts memory[0]
    if memory[0] == 19690720
      puts "Noun #{noun}, verb #{noun}"
      puts "Value: #{100 * noun + verb}"
      exit
    end
  end
end

