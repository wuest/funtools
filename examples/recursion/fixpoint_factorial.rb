#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/recursion'

class Demonstration
  # The defix method will behave the same as the 'def' keyword, defining a
  # new method in the current scope which will execute a given block, recursing
  # until a fixpoint (a value which for a given function, produces the same
  # value) is reached.
  #
  # The choice is made to order the arguments such that an accumulator can be
  # fed back into the function alone, producing the accumulator as a result.
  defix :fix_factorial do |acc, n=1|
    # Because the definition of the recursive function takes place in a block
    # context, the return keyword is not able to be used.  If multiple values
    # should be fed to the next recursion, they should be returned as an Array.
    if n < 2
      acc
    else
      [acc*n, n-1]
    end
  end
end

demo = Demonstration.new
puts demo.fix_factorial(1, 5)
