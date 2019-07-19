require 'helper'

defpattern(:main_fibonacci) do
  main_fibonacci(nil, nil, 1)   { |a,b,n=1| b }
  main_fibonacci(nil, nil, nil) { |a,b,n=1| [b, a+b, n-1] }
end

class PatternObject
  def one
    1
  end

  def two
    2
  end

  defpattern(:callable) do
    callable(1)   { |_| self.send(:one) }
    callable(2)   { |_| two }
    callable(nil) { |_| nil }
  end
end

class TestPatternMatching < Test::Unit::TestCase
  def setup
    class << self
      defpattern(:fibonacci) do
        fibonacci(nil, nil, 1)   { |a,b,n=1| b }
        fibonacci(nil, nil, nil) { |a,b,n=1| [b, a+b, n-1] }
      end

      defpattern(:array_filter) do
        array_filter([1,   1,   0])   { |a| a[1] }
        array_filter([2,   1,   nil]) { |a| a[0] }
        array_filter([nil, nil, nil]) { |_| 0 }
      end

      defpattern(:hash_filter) do
        hash_filter({a: 1,   b: 2})   { |a| a[:a] }
        hash_filter({a: 2,   b: nil}) { |a| a[:a] }
        hash_filter({a: nil, b: nil}) { |_| 0 }
      end

      defpattern(:no_catch_all) do
        no_catch_all(1) { 1 }
      end
    end
  end
  def test_pattern_matched_functions_produce_appropriate_output
    assert_equal([5, 5, 1], fibonacci(0, 5, 2))
    assert_equal(5, fibonacci(0, 5, 1))
  end

  def test_top_level_pattern_matched_functions_produce_appropriate_output
    assert_equal([5, 5, 1], main_fibonacci(0, 5, 2))
    assert_equal(5, main_fibonacci(0, 5, 1))
  end

  def test_temporary_class_methods_are_destroyed
    assert_raises(NoMethodError) { PatternObject.callable(nil) }
  end

  def test_pattern_functions_are_scoped_correctly
    pattern = PatternObject.new
    assert_equal(nil, pattern.callable(nil))
    assert_equal(1, pattern.callable(1))
    assert_equal(2, pattern.callable(2))
  end

  def test_pattern_matching_with_arrays
    assert_equal(1, array_filter([1, 1, 0]))
    assert_equal(2, array_filter([2, 1, 2]))
    assert_equal(0, array_filter([7, 0, 1]))

    assert_raises(ArgumentError) { array_filter([2, 0]) }
    assert_raises(ArgumentError) { array_filter([2, 0, 0, 0]) }
  end

  def test_pattern_matching_with_hashes
    assert_equal(1, hash_filter({a: 1, b: 2}))
    assert_equal(0, hash_filter({a: 9, b: 2}))
    assert_equal(0, hash_filter({b: 2, a: 9}))

    assert_raises(ArgumentError) { hash_filter({a: 1}) }
    assert_raises(ArgumentError) { hash_filter({a: 1, b: 2, c: 3}) }
  end

  def test_failed_matches_raises_no_match
    assert_raises(NoMatch) { no_catch_all(2) }
  end
end
