class Method
  # Public: Compose a Method.
  #
  # f - Method, Proc or Symbol describing a Proc to compose with the current
  #     method.
  #
  # Returns a composed Proc.
  def *(f)
    to_proc * f
  end
end

class Proc
  # Public: Compose a Proc.
  #
  # f - Method, Proc or Symbol describing a Proc to compose with the current
  #     Proc.
  #
  # Returns a composed Proc.
  def *(f)
    ->(*n) { self[f.to_proc[*n]] }
  end
end

class Object
  # Public: Compose a series of functions.
  #
  # f - Any number of Procs, Methods, or Symbols which should be composed.  If
  #     functions f, g, and h are composed in that order, the result will be
  #     f . g . h -> f(g(h(...)))
  #
  # Returns a composed Proc.
  def compose(*f)
    f.map do |g|
      g.is_a?(Array) ? ->(n) { g.first.to_proc[n,*g.drop(1)] } : g.to_proc
    end.reduce(&:*)
  end

  # Public: Mimic the -> macro in Clojure.
  #
  # data - Any data to be passed to the composed function.
  # f    - Any number of Procs, Methods, or Symbols which should be composed.
  #        If functions f, g, and h are composed in that order, the result will
  #        be f . g . h -> f(g(h(...)))
  #
  # Returns the result of the composed functions, called with data as the
  # argument.
  def pl(data, *f)
    compose(*f.reverse)[*[data].flatten]
  end
end
