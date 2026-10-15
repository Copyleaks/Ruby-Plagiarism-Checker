# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'copyleaks/version'

Gem::Specification.new do |spec|
  spec.name          = 'copyleaks'
  spec.version       = Copyleaks::VERSION
  spec.authors       = ['Copyleaks ltd']
  spec.email         = ['sales@copyleaks.com']

  spec.summary       = 'The official Copyleaks Ruby library.'
  spec.description   = "Copyleaks is the integrity layer for your tech stack that helps organizations and individuals understand what's human-made and original, AI-generated, or manipulated across text, image, audio and video. This SDK gives you access to the following Copyleaks products: AI Text Detection, AI Image Detection, AI Video Detection, Plagiarism Checker (Authenticity scans: file, URL, OCR), Image Plagiarism Detection, Grammar Checker, Text Moderation."
  spec.homepage      = 'https://api.copyleaks.com'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Copyleaks/Ruby-Plagiarism-Checker'
  spec.metadata['changelog_uri'] = 'https://github.com/Copyleaks/Ruby-Plagiarism-Checker/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    files = `git ls-files -z 2>/dev/null`.split("\x0")
    files = Dir['lib/**/*.rb'] + %w[README.md CHANGELOG.md LICENSE.txt copyleaks.gemspec] if files.empty?
    files.reject { |f| f.match(%r{\A(?:demo|test|spec|features)/}) || f.match(/\.gem/) }
  end
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.require_paths = ['lib']

  # Development and test only. The gem has no runtime dependencies.
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '>= 12.0'
  spec.add_development_dependency 'webrick', '~> 1.4'
end
