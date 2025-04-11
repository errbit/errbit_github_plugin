# frozen_string_literal: true

require_relative "lib/errbit_github_plugin/version"

Gem::Specification.new do |spec|
  spec.name = "errbit_github_plugin"
  spec.version = ErrbitGithubPlugin::VERSION
  spec.authors = ["Stephen Crosby"]
  spec.email = ["stevecrozz@gmail.com"]

  spec.summary = "GitHub integration for Errbit"
  spec.description = "GitHub integration for Errbit"
  spec.homepage = "https://github.com/errbit/errbit_github_plugin"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "errbit_plugin"
  spec.add_dependency "faraday-retry"
  spec.add_dependency "octokit"
  spec.add_dependency "activesupport"
end
