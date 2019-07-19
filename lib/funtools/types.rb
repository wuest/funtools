class Object
  # Internal: Check a value to make sure it conforms to a given type.
  #
  # value - Value to be checked against types.
  # type  - Type definition to be used for type checking.
  #
  # Raises TypeError if the value does not match the expected type.
  # Returns value.
  check_type = ->(value, type) do
    case type
    when Class, Module
      unless value.is_a?(type)
        raise(TypeError, "Expected #{type}; got #{value.class}")
      end
    when Enumerable
      unless type.map { |kind| value.is_a?(kind) }.any?
        raise(TypeError, "Expected one of: #{type.join(', ')}; got #{value.class}")
      end
    else
      raise(TypeError, "Unable to test type against #{type.class}")
    end
    value
  end

  # Internal: Align a set of expected types with the arguments given in a
  # method call.
  #
  # typedefs - Array of types against which arguments should be checked.
  # a        - Array of arguments passed to a given method.
  #
  # Returns a 2-dimensional Array containing [Typedef, Value].
  align_types = ->(typedefs, a) do
    pivot = typedefs.index(typedefs.select { |k,n| k == :rest }.flatten)

    if pivot
      types_min = pivot + 1
      args_num  = a.length - types_min
      rest_min  = a.length - (args_num + 1)

      typedefs[0...pivot].to_a.zip(a[0...pivot].to_a) +
      a[pivot, args_num].to_a.zip([typedefs[pivot]].cycle).map(&:reverse) +
      typedefs[types_min..-1].to_a.zip(a[rest_min..-1].to_a)
    else
      typedefs.zip(a)
    end.reject { |t, v| v.nil? && t.first == :opt }.map { |t, v| [v, t.last] }
  end

  # Public: Define a method in the current scope which wraps an already-defined
  # method, enforcing a type check on all arguments and the return value.
  #
  # sym   - Symbol defining the name of the method to be created.
  # args  - Zero or more types specified to correspond to arguments expected to
  #         be passed to the method in question.
  # ret   - Type the method in question is expected to return.
  #
  # Returns nothing.
  define_method(:settype) do |sym, *args, ret|
    message    = :define_method if respond_to?(:define_method, true)
    message  ||= :define_singleton_method
    old_method = begin method(sym) rescue instance_method(sym) end
    params     = old_method.parameters

    typedefs = old_method.parameters.select do |kind,_|
      kind != :block
    end.each_with_index.map do |req,index|
      [req.first, args[index]]
    end

    self.send(message, sym) do |*n, &b|
      method = old_method.is_a?(Method) ? old_method : old_method.bind(self)
      align_types.(typedefs, n).each { |pair| check_type.(*pair) }
      check_type.(method.(*n, &b), ret)
    end
  end
end
