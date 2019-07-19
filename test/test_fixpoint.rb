require 'helper'

defix(:main_factorial_fixpoint) { |acc, n=1| n < 2 ?  acc : [n * acc, n-1] }
def main_factorial(n)
  main_factorial_fixpoint(1, n)
end

class RecursiveObject
  def one
    1
  end
  defix(:instance_one) { |n| one }
end

class TestRecursion < Test::Unit::TestCase
  def setup
    class << self
      defix(:fixpoint_factorial) { |acc, n=1| n < 2 ?  acc : [n * acc, n-1] }
      def factorial(n)
        fixpoint_factorial(1, n)
      end
    end
  end

  def test_recursive_functions_produce_appropriate_output
    assert_equal(120, factorial(5))
  end

  def test_toplevel_functions_work_correctly
    assert_equal(120, main_factorial(5))
  end

  def test_recursive_functions_are_scoped_correctly
    recursive = RecursiveObject.new
    assert_equal(1, recursive.instance_one)
  end
end
