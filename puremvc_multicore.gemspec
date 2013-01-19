# encoding: utf-8 

require File.expand_path('../lib/puremvc/multicore/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = ["Oliver Feldt"]
  gem.email       = ['oliver.feldt@googlemail.com'] 
  gem.description = 'Ruby Port of PureMVC MultiCore version'
  gem.summary     ='A library for building MVC-structured projects'

  gem.name        = 'puremvc_multicore'
  gem.version     = PureMVC::MultiCore::VERSION
  gem.platform    = Gem::Platform::RUBY 
  gem.licenses    = ['See LICENSE FILE']
  gem.homepage    = "http://puremvc.org"
  gem.date        = "2009-10-18"

  gem.add_development_dependency 'rspec', '~> 2.12.0'
  gem.add_development_dependency 'pry', '~> 0.9.11.3'

  gem.files = `git ls-files`.split($\)
  gem.require_paths = ["lib"]
end
