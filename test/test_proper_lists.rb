require 'helper'

class TestProperLists < Test::Unit::TestCase
  def test_cons_creation
    cells = cons 1, 2
    assert_equal(1, cells.car)
    assert_equal(2, cells.cdr)
  end

  def test_to_array
    cells = cons(1, cons(2, cons(3, nil)))
    array = [1, 2, 3]
    assert_equal(array, cells.to_a)
  end

  def test_large_arrays_dont_overflow_the_stack
    cells = (0..10000).to_a.reverse.reduce(nil) { |c, e| cons(e, c) }
    assert_equal([*(0..10000)], cells.to_a)
  end

  def test_arbitrary_list_creation
    cells  = list(1, 2, 3, 4, 5)
    single = list(1)

    expected_cells = (1..5).to_a.reverse.reduce(nil) { |c, e| cons(e, c) }

    assert_equal(expected_cells, cells)
    assert_equal([1], single.to_a)
  end

  def test_equality_test
    cells    = list(1, 2, 3, 4, 5)
    array    = [*(1..5)]
    expected = array.reverse.reduce(nil) { |c, e| Cons.new(e, c) }

    assert_equal(expected, cells)
    refute_equal(array, cells)
  end

  def test_deeply_nested_car_elements_do_not_overflow_the_stack
    cells = [*(1..10000)].reverse.reduce(nil) { |c,e| Cons.new(c, e) }

    if ENV['SLOWTESTS']
      assert_nothing_raised { cells.inspect }
    end
  end

  def test_string_coersion
    list_cells                = list(1, 2, 3, 4, 5)
    list_expected             = '(1 2 3 4 5)'
    unproper_list             = cons(cons(cons(cons(1, 2), 3), 4), 5)
    unproper_expected         = '((((1 2) 3) 4) 5)'
    shallow_tree              = cons(cons(1, 2), cons(3, 4))
    shallow_tree_expected     = '((1 2) (3 4))'

    deep_ex = '((((1 2) (3 4)) ((5 6) (7 8))) (((9 0) (1 2)) ((3 4) (5 6))))'
    deep    = cons(cons(cons(cons(1, 2), cons(3, 4)),
                        cons(cons(5, 6), cons(7, 8))),
                   cons(cons(cons(9, 0), cons(1, 2)),
                        cons(cons(3, 4), cons(5, 6))))

    assert_equal(list_expected, list_cells.to_s)
    assert_equal(unproper_expected, unproper_list.to_s)
    assert_equal(shallow_tree_expected, shallow_tree.to_s)
    assert_equal(deep_ex, deep.to_s)
  end
end
