# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'search_warrant'

Gem::Specification.new do |spec|
  spec.name          = "search_warrant"
  spec.version       = SearchWarrant::VERSION
  spec.authors       = ["Tom Lord"]
  spec.email         = ["tom.lord@comlaude.com"]

  spec.summary       = %q{Trace all method calls on instances of a given class}
  spec.homepage      = "https://github.com/tom-lord/search_warrant"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
