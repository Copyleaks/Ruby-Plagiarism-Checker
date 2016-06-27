# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'copyleaks_api/version'

Gem::Specification.new do |spec|
  spec.name          = "plagiarism-checker"
  spec.version       = CopyleaksApi::VERSION
  spec.authors       = ["Copyleaks ltd"]
  spec.email         = ["sales@copyleaks.com"]

  spec.summary       = %q{Detects plagiarism and checks content distribution online.}
  spec.description   = %q{Copyleaks detects plagiarism and checks content distribution online. Use Copyleaks to find out if textual content is original and if it has been used before. With Copyleaks cloud publishers, academics, and more can scan files (pdf, doc, docx, ocr...), URLs and free text for plagiarism check.}
  spec.homepage      = "https://api.copyleaks.com"
  spec.license       = "MIT"
  
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
