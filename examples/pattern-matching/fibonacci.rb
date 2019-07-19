#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/pattern-matching'

class InstanceMethodDemonstration
  # The defpattern method, included from PatternMatching, will behave the same
  # as the 'def' keyword, defining a new method.  The block passed to the
  # method will have a method available to it sharing the name of the method
  # which will be created, allowing a pattern matching syntax similar to
  # Erlang's to be utilized.
  defpattern(:fibonacci) do
    fibonacci(nil, nil, 1)   { |a,_,_| a }
    fibonacci(nil, nil, nil) { |a,b,n| [a+b, a, n-1] }
  end
end

demo = InstanceMethodDemonstration.new
puts demo.fibonacci(1,0,1)
