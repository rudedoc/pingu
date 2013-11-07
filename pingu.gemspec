# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pingu/version'

Gem::Specification.new do |spec|
  spec.name          = "pingu"
  spec.version       = Pingu::VERSION
  spec.authors       = ["rudedoc"]
  spec.email         = ["finlay.mark@gmail.com"]
  spec.description   = %q{Pings a list of routers}
  spec.summary       = %q{Pings a list of routers, sends a text when something is up!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
