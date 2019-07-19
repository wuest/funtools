require 'helper'

class TypedClass
  def instance_method_typed(val)
    val + 1
  end
  settype(:instance_method_typed, Fixnum, Fixnum)

  class << self
    def class_method_typed(val)
      val + 1
    end
    settype(:class_method_typed, Fixnum, Fixnum)
  end
end

def simple_type_checked(val)
  val + 1
end

def rest_at_end(val, *rest)
  val + rest.reduce(&:+).to_i
end

def rest_at_beginning(*rest, val)
  val + rest.reduce(&:+).to_i
end

def rest_in_middle(val1, *rest, val2)
  val1 + rest.reduce(&:+).to_i + val2
end

def optional_params(val, opt=2)
  val + opt
end

def optional_with_rest(val, val2=1, *rest)
  val + val2 + rest.reduce(&:+).to_i
end

settype(:simple_type_checked, Numeric, Numeric)
settype(:rest_at_end,         Fixnum, Fixnum, Fixnum)
settype(:rest_at_beginning,   Fixnum, Fixnum, Fixnum)
settype(:rest_in_middle,      Fixnum, Fixnum, Fixnum, Fixnum)
settype(:optional_params,     Fixnum, Fixnum, Fixnum)
settype(:optional_with_rest,  Fixnum, Fixnum, Fixnum, Fixnum)

class TestArgumentTypeChecking < Test::Unit::TestCase
  def test_simple_type_checked
    assert_raises(TypeError) { simple_type_checked("1") }
    assert_equal(2, simple_type_checked(1))
  end

  def test_rest_at_end_of_function
    assert_raises(TypeError) { rest_at_end() }
    assert_equal(1, rest_at_end(1))
    assert_equal(3, rest_at_end(1, 1, 1))
  end

  def test_rest_at_beginning_of_function
    assert_raises(TypeError) { rest_at_beginning() }
    assert_equal(1, rest_at_beginning(1))
    assert_equal(3, rest_at_beginning(1, 1, 1))
  end

  def test_rest_in_middle_of_function
    assert_raises(TypeError) { rest_in_middle() }
    assert_equal(2, rest_in_middle(1, 1))
    assert_equal(4, rest_in_middle(1, 1, 1, 1))
  end

  def test_optional_parameters_work_as_expected
    assert_raises(TypeError) { optional_params() }
    assert_equal(3, optional_params(1))
  end

  def test_optional_parameters_with_rest
    assert_raises(TypeError) { optional_with_rest() }
    assert_equal(2, optional_with_rest(1))
    assert_equal(3, optional_with_rest(1, 2))
    assert_equal(4, optional_with_rest(1, 1, 1, 1))
  end

  def test_instance_methods
    assert_equal(2, TypedClass.new.instance_method_typed(1))
    assert_equal(2, TypedClass.class_method_typed(1))
  end
end

def incorrect_return_type(a)
  a.to_s
end

settype(:incorrect_return_type, Fixnum, Fixnum)

class TestReturnTypeChecking < Test::Unit::TestCase
  def test_incorrect_return_types_fail
    assert_raises(TypeError) { incorrect_return_type(1) }
  end
end
