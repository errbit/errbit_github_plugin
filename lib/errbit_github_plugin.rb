# frozen_string_literal: true

require "errbit_github_plugin/version"
require "errbit_github_plugin/error"
require "errbit_github_plugin/issue_tracker"

module ErrbitGithubPlugin
  def self.root
    File.expand_path "../..", __FILE__
  end

  def self.read_static_file(file)
    File.read(File.join(root, "static", file))
  end
end

ErrbitPlugin::Registry.add_issue_tracker(ErrbitGithubPlugin::IssueTracker)
