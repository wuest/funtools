#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/recursion'

class Demonstration
  # The deftail method defines a new method in the current scope which will
  # execute a given block, returning normally unless the method is called as
  # its final value, in which case tail recursion is mimiced.
  deftail :tail_fibonacci do |n, a=1, b=0|
    if n < 2
      a
    else
      tail_fibonacci(n-1, a+b, a)
    end
  end
end

demo = Demonstration.new
puts demo.tail_fibonacci(15)
