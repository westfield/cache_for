# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cache_for/version'

Gem::Specification.new do |spec|
  spec.name          = "cache_for"
  spec.version       = CacheFor::VERSION
  spec.authors       = ["Michael Mell"]
  spec.email         = ["mike.mell@nthwave.net"]
  spec.description   = %q{Provide a simple interface to redis with self-expiring keys.}
  spec.summary       = %q{Provide a simple interface to redis with self-expiring keys.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "spec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency 'redis'
end
