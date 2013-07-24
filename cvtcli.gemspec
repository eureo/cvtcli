# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cvtcli/version'

Gem::Specification.new do |gem|
  gem.name          = "cvtcli"
  gem.version       = Cvtcli::VERSION
  gem.authors       = ["Franck D'agostini"]
  gem.email         = ["franck.dagostini@gmail.com"]
  gem.description   = %q{Client gem for Cvtheque server api}
  gem.summary       = %q{Client gem for Cvtheque server api}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency('rest-client')

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency('fakeweb')
end
