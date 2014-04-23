# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ratchetify/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Kuehl"]
  gem.license       = 'MIT'
  gem.email         = ["michael@ratchet.cc"]
  gem.description   = %q{Deploy Rails apps on Uberspace}
  gem.summary       = %q{Ratchetify helps you deploy a Ruby on Rails app on uberspace.de, a popular German shared hosting provider.}
  gem.homepage      = "https://github.com/ratchetcc/ratchetify"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ratchetify"
  gem.require_paths = ["lib"]
  gem.version       = Ratchetify::VERSION

  # dependencies for capistrano
  gem.add_dependency 'capistrano',        '2.12.0'
  
end
