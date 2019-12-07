#!/usr/bin/env ruby

# Intcode Assembler

require './libintcode'

$MN = $TOKENS.values
$DIR = [
  :def
]
$OPS = []
$LABELS = {}

def add(arg1, arg2, dest)
  $OPS << 1 << arg1 << arg2 << dest
end

def mul(arg1, arg2, dest)
  $OPS << 2 << arg1 << arg2 << dest
end

def lbl(sym)
  $LABELS[sym] = $OPS.size
end

fn = ARGV[0]
eval File.read fn
File.write "#{File.basename fn}.int", $OPS.join(?,)
