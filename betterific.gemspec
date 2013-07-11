# -*- encoding: utf-8 -*-
require File.expand_path('../lib/betterific/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brad Cater"]
  gem.email         = ["bradcater@gmail.com"]
  gem.description   = %q{This gem is a Ruby interface to the Betterific API.}
  gem.summary       = %q{This gem is a Ruby interface to the Betterific API. It provides support via JSON, RSS, XML, and Protocol Buffers.}
  gem.homepage      = "https://github.com/bradcater/betterific"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "betterific"
  gem.require_paths = ["lib"]
  gem.version       = Betterific::VERSION

  gem.add_dependency 'hashie', '~> 2.0.5'
  gem.add_dependency 'json', '~> 1.8.0'

  gem.add_development_dependency 'ruby-protocol-buffers', '~> 2.4.0'
  gem.add_development_dependency 'rspec', '~> 2.13.0'
end
