require "errbit_github_plugin/version"
require "errbit_github_plugin/engine"
require "errbit_github_plugin/error"
require "errbit_github_plugin/issue_tracker"

module ErrbitGithubPlugin
end

ErrbitPlugin::Registry.add_issue_tracker(ErrbitGithubPlugin::IssueTracker)
