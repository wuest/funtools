$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'funtools'

Gem::Specification.new do |s|
  s.name = 'funtools'
  s.version = Funtools::VERSION

  s.description = 'Tools to assist in programming in a more functional style'
  s.summary     = 'Functional programming tools'
  s.authors     = ['Tina Wuest']
  s.email       = 'tina@wuest.me'
  s.homepage    = 'https://github.com/wuest/funtools'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.files = `git ls-files lib`.split("\n")
end
