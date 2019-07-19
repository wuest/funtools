class Object
  # Public: Define a method in the current scope which allow pattern matching
  # function declaration to be used.
  #
  # sym   - Symbol defining the name of the method to be created.
  # block - Block containing the logic for the function to be created.
  #
  # Returns nothing.
  def defpattern(sym)
    match = ->(a, b) do
      if([a,b].map { |o| o.is_a?(Enumerable) && a.class == b.class }.all?)
        raise ArgumentError unless a.length == b.length

        zipped = a.is_a?(Hash) ? a.sort.zip(b.sort) : a.zip(b)

        zipped.reduce(true) do |c, e|
          c && match.(*e)
        end
      else
        a.nil? || a == b
      end
    end

    old_method = self.class.method(sym) if self.class.method_defined?(:sym)
    patterns = []
    self.class.send(:define_method, sym) do |*l, &b|
      patterns << ->(*n) do
        ->(*m) do
          if m.length == n.length
            e = m.zip(n)
            raise NoMatch if e.reject { |e| match.(*e) }.any?
            instance_exec(*n, &b)
          end
        end.(*l)
      end
    end

    yield

    if old_method
      self.class.send(:define_method, sym, &old_method)
    else
      self.class.send(:remove_method, sym)
    end

    message   = :define_method if respond_to?(:define_method, true)
    message ||= :define_singleton_method
    self.send(message, sym) do |*args|
      patterns.each do |pattern|
        begin
          return instance_exec(*args, &pattern)
        rescue NoMatch
        end
      end
      instance_exec { raise NoMatch }
    end
  end
end

class NoMatch < ArgumentError; end
