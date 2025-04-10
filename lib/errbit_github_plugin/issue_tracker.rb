# frozen_string_literal: true

require "octokit"

module ErrbitGithubPlugin
  class IssueTracker < ErrbitPlugin::IssueTracker
    LABEL = "github"

    NOTE = "Please configure your github repository in the <strong>GITHUB " \
           "REPO</strong> field above.<br/> Instead of providing your " \
           "username & password, you can link your Github account to your " \
           "user profile, and allow Errbit to create issues using your " \
           "OAuth token."

    FIELDS = {
      username: {
        placeholder: "Your username on GitHub"
      },
      password: {
        placeholder: "Password for your account"
      }
    }

    def self.label
      LABEL
    end

    def self.note
      NOTE
    end

    def self.fields
      FIELDS
    end

    def self.icons
      @icons ||= {
        create: [
          "image/png", ErrbitGithubPlugin.read_static_file("github_create.png")
        ],
        goto: [
          "image/png", ErrbitGithubPlugin.read_static_file("github_goto.png")
        ],
        inactive: [
          "image/png", ErrbitGithubPlugin.read_static_file("github_inactive.png")
        ]
      }
    end

    def configured?
      errors.empty?
    end

    def url
      "https://github.com/#{repo}/issues"
    end

    def errors
      errors = []
      if self.class.fields.detect { |f| options[f[0]].blank? }
        errors << [:base, "You must specify your GitHub username and password"]
      end
      if repo.blank?
        errors << [:base, "You must specify your GitHub repository url."]
      end
      errors
    end

    def repo
      options[:github_repo]
    end

    def create_issue(title, body, user: {})
      github_client = if user["github_login"] && user["github_oauth_token"]
        Octokit::Client.new(
          login: user["github_login"], access_token: user["github_oauth_token"]
        )
      else
        Octokit::Client.new(
          login: options["username"], password: options["password"]
        )
      end
      issue = github_client.create_issue(repo, title, body)
      issue.html_url
    rescue Octokit::Unauthorized
      raise ErrbitGithubPlugin::AuthenticationError, "Could not authenticate with GitHub. Please check your username and password."
    end

    def close_issue(url, user: {})
      github_client = if user["github_login"] && user["github_oauth_token"]
        Octokit::Client.new(
          login: user["github_login"], access_token: user["github_oauth_token"]
        )
      else
        Octokit::Client.new(
          login: options["username"], password: options["password"]
        )
      end
      # It would be better to get the number from issue.number when we create the issue,
      # however, since we only have the url, get the number from it.
      # ex: "https://github.com/octocat/Hello-World/issues/1347"
      issue_number = url.split("/").last
      issue = github_client.close_issue(repo, issue_number)
      issue.html_url
    rescue Octokit::Unauthorized
      raise ErrbitGithubPlugin::AuthenticationError, "Could not authenticate with GitHub. Please check your username and password."
    end
  end
end
