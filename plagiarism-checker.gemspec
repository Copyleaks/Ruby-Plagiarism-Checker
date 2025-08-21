# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'copyleaks/version'

Gem::Specification.new do |spec|
  spec.name          = 'plagiarism-checker'
  spec.version       = Copyleaks::VERSION
  spec.authors       = ['Copyleaks ltd']
  spec.email         = ['sales@copyleaks.com']

  spec.summary       = 'Detects plagiarism and checks content distribution online.'
  spec.description   = 'Copyleaks detects plagiarism and checks content distribution online. Use Copyleaks to find out if textual content is original and if it has been used before. With Copyleaks cloud publishers, academics, and more can scan files (pdf, doc, docx, ocr...), URLs and free text for plagiarism check.'
  spec.homepage      = 'https://api.copyleaks.com'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Copyleaks/Ruby-Plagiarism-Checker'
  spec.metadata['changelog_uri'] = 'https://github.com/Copyleaks/Ruby-Plagiarism-Checker/releases'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:demo|test|spec|features)/}) || f.match(/\.gem/) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
