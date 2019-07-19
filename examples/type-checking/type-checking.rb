#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/types'

def add_numbers(a, b)
  a + b
end

def add_ints(a, b)
  a + b
end

# Type definitions are ordered the same ways as in Haskell: arg, arg... return.
# This definition is equivalent to:
# add_numbers :: Numeric -> Numeric -> Numeric
settype(:add_numbers, Numeric, Numeric, Numeric)

# When an argument or the return type may be one of several types, an Array
# containing all possibilities may be provided.  This allows a high level of
# specificity and flexibility.
settype(:add_ints, [Fixnum, Bignum], [Fixnum, Bignum], [Fixnum, Bignum])

puts "add_numbers with expected args (5, 10): #{add_numbers(5, 10)}"

begin
  print "add_numbers with unexpected args (5, '10'): "
  puts add_numbers(5, '10')
rescue TypeError => e
  print "Caught #{e.class}: "
  puts e.message
end

puts "add_ints with expected args (5, 10): #{add_ints(5, 10)}"

begin
  print "add_ints with unexpected args (5, 10.0): "
  puts add_ints(5, 10.0)
rescue TypeError => e
  print "Caught #{e.class}: "
  puts e.message
end
