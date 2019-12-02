#!/usr/bin/ruby

# AoC 2019 Day 2

f = File.read 'input.txt'

main_sum = 0

f.lines.each do |l|
  sum = l.to_i / 3 - 2
  new_req = sum

  until (new_req / 3 - 2) <= 0
    new_req = new_req / 3 - 2
    sum += new_req
  end

  main_sum += sum
end



puts main_sum
