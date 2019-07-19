#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/pattern-matching'
require 'funtools/recursion'

defpattern(:fibonacci_iter) do
  fibonacci_iter(nil, nil, 1)   { |a,_,_| a }
  fibonacci_iter(nil, nil, nil) { |a,b,n| [a+b, a, n-1] }
end
deftail(:fibonacci_tail) { |a, b=0, n=1| fibonacci_iter(a, b, n) }

puts fibonacci_tail(1, 0, 10)
