# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errbit_github_plugin/version'

Gem::Specification.new do |spec|
  spec.name          = "errbit_github_plugin"
  spec.version       = ErrbitGithubPlugin::VERSION
  spec.authors       = ["Cyril Mougel"]
  spec.email         = ["cyril.mougel@gmail.com"]
  spec.description   = %q{Add Github issue tracker plugin to errbit}
  spec.summary       = %q{Add Github issue tracker plugin to errbit}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "errbit_plugin"
  spec.add_dependency "octokit"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
