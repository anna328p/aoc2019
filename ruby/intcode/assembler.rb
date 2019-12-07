#!/usr/bin/env ruby

# Intcode Assembler

require './libintcode'

$MN = $TOKENS.values
$DIR = [
  :def
]
$OPS = []
$LABELS = {}

class Kernel
  class <<self
    $INSTRUCTIONS.each do |ins|
      define_method ins do |*args|
        $OPS << tokens.invert[ins.name]
        args.each 
      end
    end
  end
end

def lbl(sym)
  $LABELS[sym] = $OPS.size
end

fn = ARGV[0]
eval File.read fn
File.write "#{File.basename fn}.int", $OPS.join(?,)
