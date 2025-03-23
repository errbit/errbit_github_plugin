# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errbit_github_plugin/version'

Gem::Specification.new do |spec|
  spec.name          = 'errbit_github_plugin'
  spec.version       = ErrbitGithubPlugin::VERSION
  spec.authors       = ['Stephen Crosby']
  spec.email         = ['stevecrozz@gmail.com']

  spec.description   = %q{GitHub integration for Errbit}
  spec.summary       = %q{GitHub integration for Errbit}
  spec.homepage      = 'https://github.com/errbit/errbit_github_plugin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'errbit_plugin'
  spec.add_dependency 'railties', ">= 6.1.0"
  spec.add_dependency 'octokit'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'activesupport'
end
