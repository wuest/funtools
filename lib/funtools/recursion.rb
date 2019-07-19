module Funtools
  class RecurseArgs < Array; end
end

class Object
  # Public: Define a method in the current scope which will execute a given
  # block recursively until a fixpoint is reached.
  #
  # sym   - Symbol defining the name of the method to be created.
  # block - Block containing the logic for the function to be created.
  #
  # Returns nothing.
  def defix(sym, &block)
    message   = :define_method if respond_to?(:define_method, true)
    message ||= :define_singleton_method
    self.send(message, sym) do |*n|
      last = nil
      [1].cycle.reduce(n) do |c, e|
        break c if last == c
        last = c
        instance_exec(c, &block)
      end
    end
  end

  # Public: Define a method in the current scope which will execute a given
  # block in such a manner that recursive calls are handled properly so long as
  # the call constitutes tail recursion.
  #
  # sym   - Symbol defining the name of the method to be created.
  # block - Block containing the logic for the function to be created.
  #
  # Returns nothing.
  def deftail(sym, &block)
    message   = :define_method if respond_to?(:define_method, true)
    message ||= :define_singleton_method

    self.send(message, sym) do |*n|
      instance_exec { self.dup }.instance_exec do
        class << self
          self
        end.class_eval do
          define_method(sym) { |*a| Funtools::RecurseArgs.new(a) }
        end

        loop do
          n = instance_exec(*n, &block)
          return n unless n.is_a?(Funtools::RecurseArgs)
        end
      end
    end
  end
end
