require 'helper'

class TestComposition < Test::Unit::TestCase
  def test_method_composition_returns_proc
    assert((method(:p) * method(:p)).is_a?(Proc))
  end

  def test_composition_with_methods
    plus  = 20.method(:+)
    minus = 150.method(:-)
    assert_equal(120, compose(minus, plus)[10])
  end

  def test_composition_with_procs
    plus  = ->(n) { 20 + n }
    minus = ->(n) { 150 - n }
    assert_equal(120, compose(minus, plus)[10])
  end

  def test_composition_with_symbols
    plus  = ->(n) { 20 + n }
    minus = ->(n) { 150 - n }
    assert_equal('FF', compose(:upcase, :to_s)[255, 16])
  end

  def test_composition_with_mixed_types
    plus = 101.method(:+)
    double = ->(n) { n * 2 }
    assert_equal('255', compose(:to_s, plus, double)[77])
  end

  def test_composition_with_arrays
    plus = 101.method(:+)
    double = ->(n) { n * 2 }
    assert_equal('FF', compose(:upcase, [:to_s, 16], plus, double)[77])
  end

  def test_pipeline
    assert_equal('5', pl(25, [:/, 5], :to_s))
  end
end
