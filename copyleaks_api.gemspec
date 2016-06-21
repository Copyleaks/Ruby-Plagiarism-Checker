# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copyleaks_api/version'

Gem::Specification.new do |spec|
  spec.name          = "plagiarism-checker"
  spec.version       = CopyleaksApi::VERSION
  spec.authors       = ["Copyleaks"]
  spec.email         = ["Support@copyleaks.com"]

  spec.summary       = %q{SDK for Copyleaks API}
  spec.description   = %q{SDK for Copyleaks API}
  spec.homepage      = "https://github.com/Copyleaks/Ruby-Plagiarism-Checker/commits"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency 'mimemagic'
end
