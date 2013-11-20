require "errbit_github_plugin/version"
require 'errbit_github_plugin/error'
require 'errbit_github_plugin/issue_tracker'
require 'errbit_github_plugin/rails'

ErrbitPlugin::Register.add_issue_tracker(
  'IssueTrackers::GithubIssuesTracker',
  ErrbitGithubPlugin::IssueTracker
)
