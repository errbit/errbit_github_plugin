require "errbit_github_plugin/version"
require 'errbit_github_plugin/error'
require 'errbit_github_plugin/issue_tracker'
require 'errbit_github_plugin/rails'

module ErrbitGithubPlugin
  def self.root
    File.expand_path '../..', __FILE__
  end
end

ErrbitPlugin::Registry.add_issue_tracker(ErrbitGithubPlugin::IssueTracker)
