$:.push File.expand_path('../lib', __FILE__)
require 'filmbuff/version'

Gem::Specification.new do |s|
  s.name        = 'filmbuff'
  s.version     = FilmBuff::VERSION
  s.authors     = ['Kristoffer Sachse']
  s.email       = ['hello@kristoffer.is']
  s.homepage    = 'https://github.com/sachse/filmbuff'
  s.summary     = 'A Ruby wrapper for IMDb\'s JSON API'
  s.description = 'Film Buff provides a Ruby wrapper for IMDb\'s JSON API, ' <<
                  'which is the fastest and easiest way to get information ' <<
                  'from IMDb.'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.0.0'

  s.add_dependency('http', '~> 0.9.3')

  s.add_development_dependency('minitest', '>= 1.4.0')
  s.add_development_dependency('vcr', '>= 2.4')
  s.add_development_dependency('webmock')
  s.add_development_dependency('yard', '>= 0.8.5.2')
  s.add_development_dependency('kramdown')
  s.add_development_dependency('rake')
  s.add_development_dependency('coveralls')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']
end
