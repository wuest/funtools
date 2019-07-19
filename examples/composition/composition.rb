#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/composition'

# Procs and Method objects can be composed directly via the * operator,
# resulting in a new Proc.
add_two = ->(n) { n + 2 }
mul_ten = 10.method(:*)
add_two_mul_ten = mul_ten * add_two
puts add_two_mul_ten[5]

# The compose function allows 2+ functions to be composed directly.  Symbols
# will be converted to procs, and Arrays will have the first element converted
# to a proc, and any additional members passed to the 2nd+ arguments in a given
# method call.
# The following is the equivalent to the above:
add_two_mul_ten_new = compose([:*, 10], [:+, 2])
puts add_two_mul_ten_new[5]

# Generate a list of the single digit hexadecimal numbers, and print them out.
# Since the result of composition is a Proc, the result can be used directly in
# a call to Enumerable#map with the & syntax.
puts (0..15).map(&compose(:upcase, [:to_s, 16])).join(', ')

# Take a 32 bit number and print it as a little-endian number, as if moving to
# a CPU register.
puts pl(3735928559,
        [:to_s, 16],
        :chars,
        [:each_slice, 2],
        :to_a,
        :reverse,
        :join,
        :upcase
       )
