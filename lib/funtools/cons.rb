class Object
  # Public: Wrap Cons.new to construct a new Cons cell.
  #
  # left  - Any Object to be the left element of the cell.
  # right - Any Object to be the right element of the cell.
  #
  # Returns a Cons cell.
  def cons(left, right)
    Cons.new(left, right)
  end

  # Public: Construct a list of nested Cons cells.
  #
  # first  - Any Object to be the leftmost element of the list.
  # second - Any Object to be the second element of the list (default: nil).
  # rest   - Any number of Objects to serve as elements in the list.
  #
  # Returns a list (nested Cons cells).
  def list(first, second = nil, *rest)
    set = (rest.empty? && second.nil?) ? [] : rest + [nil]
    ([first, second] + set).reverse.reduce { |c, e| Cons.new(e, c) }
  end
end

class Cons
  include Enumerable

  attr_reader :car, :cdr

  alias :head :car
  alias :tail :cdr

  # Public: Create a Cons cell.
  #
  # left  - Any Object to be the left element of the cell.
  # right - Any Object to be the right element of the cell.
  def initialize(left, right)
    @car = left
    @cdr = right
  end

  # Public: Iterate through each element of a Cons cell/list.  Note that Cons
  # cells will be yielded without inspecting their contents if they are in the
  # left position of a parent Cons cell.
  #
  # Yields each element.
  def each(&block)
    block.(car)
    left, right = car, cdr

    while right
      if right.is_a?(Cons)
        if left.is_a?(Cons)
          block.(right)
          right = nil
        else
          block.(right.car)
          left, right = right.car, right.cdr
        end
      else
        block.(right) unless right.nil?
        right = nil
      end
    end
  end

  # Public: Determine whether two Cons cells/lists are equivalent.
  #
  # other - Object to be compared against.
  #
  # Returns true or false.
  def ==(other)
    return false unless other.is_a?(Cons)
    to_a == other.to_a
  end

  # Public: Produce a string representation of a Cons cell/list.
  #
  # Returns a String.
  def inspect
    result = [self]
    while result.grep(Cons).any?
      result = result.map do |e|
        e.is_a?(Cons) ? ['(', e.to_a.zip([' '].cycle).flatten[0..-2], ')'] :
        e.nil? ? 'nil' : e
      end.flatten
    end
    result.map(&:to_s).join
  end
  alias :to_s :inspect
end
