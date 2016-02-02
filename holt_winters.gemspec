# -*- mode: ruby; encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'holt_winters/version'

Gem::Specification.new do |s|
  s.name        = 'holt_winters'
  s.version     = HoltWinters::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Brandon Keene']
  s.email       = ['bkeene@gmail.com']
  s.homepage    = ''
  s.summary     = %q{Holt-Winters Triple Exponential Smoothing}

  s.rubyforge_project = 'holt_winters'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'rubocop'
end
