# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "errbit_github_plugin/version"

Gem::Specification.new do |spec|
  spec.name = "errbit_github_plugin"
  spec.version = ErrbitGithubPlugin::VERSION
  spec.authors = ["Stephen Crosby"]
  spec.email = ["stevecrozz@gmail.com"]

  spec.description = "GitHub integration for Errbit"
  spec.summary = "GitHub integration for Errbit"
  spec.homepage = "https://github.com/errbit/errbit_github_plugin"
  spec.license = "MIT"

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "errbit_plugin"
  spec.add_dependency "faraday-retry"
  spec.add_dependency "octokit"
  spec.add_dependency "activesupport"
end
