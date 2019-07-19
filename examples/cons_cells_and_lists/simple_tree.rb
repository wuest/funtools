#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/cons'

# Example taken out of Structure and Interpretation of Computer Programs 2.2.2,
# Hierarchical Structures
#
# cons and list methods are provided to create individual cons cells as well as
# lists composed of joined cons cells terminated by nil.
tree = cons(list(1, 2), list(3, 4))

def count_leaves(x)
  return 0 if x.nil?
  return 1 unless x.is_a?(Cons)
  count_leaves(x.car) + count_leaves(x.cdr)
end

puts "The tree: #{tree} has #{count_leaves(tree)} leaves."
