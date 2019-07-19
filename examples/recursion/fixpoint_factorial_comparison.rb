#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'funtools/recursion'

# Define a recursive factorial function which is expected to fail running under
# MRI, as well as a helper function to make calling it nicer.
def bad_tail_factorial(acc, n)
  n < 2 ? acc : bad_tail_factorial(acc * n, n-1)
end
def bad_factorial(n)
  bad_tail_factorial(1, n)
end

# Try a series of tests with the recursive factorial function.  It's expected
# that the third call will raise a SystemStackError due to too much recursion.
begin
  puts 'Attempting to run recursive factorial...'
  print "5!     = "; puts "#{bad_factorial(5)}"
  print "10!    = "; puts "#{bad_factorial(10)}"
  print "10000! = "; puts "#{bad_factorial(10000)[0..19]}..."
  puts "No SystemStackErrors caught!"
rescue SystemStackError
  puts
  puts 'Caught SystemStackError, could not recurse further.'
ensure
  puts; puts
end

# Define a tail-recursive factorial function with the defix method, which is
# expected to recurse until a fixpoint is reached.
defix(:fix_factorial) do |acc, n=1|
  n < 2 ? acc : [acc * n, n-1]
end
def factorial(n)
  fix_factorial(1, n)
end

# Run the same series of tests as before, this time against our new methods.
# Since the factorial of 10000 is very long, only the first 19 digits will be
# printed; this prevents the console from being flooded, causing all other
# output to be lost.
begin
  puts 'Attempting to run fixpoint factorial via funtools...'
  print "5!     = "; puts "#{factorial(5)}"
  print "10!    = "; puts "#{factorial(10)}"
  print "10000! = "; puts "#{factorial(10000).to_s[0..19]}..."
  puts "No SystemStackErrors caught!"
rescue SystemStackError
  puts 'Caught SystemStackError, could not recurse further.'
end
