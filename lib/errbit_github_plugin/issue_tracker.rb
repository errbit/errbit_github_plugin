require 'octokit'

module ErrbitGithubPlugin
  class IssueTracker < ErrbitPlugin::IssueTracker

    LABEL = 'github'

    NOTE = 'Please configure your github repository in the <strong>GITHUB ' <<
           'REPO</strong> field above.<br/> Instead of providing your ' <<
           'username & password, you can link your Github account to your ' <<
           'user profile, and allow Errbit to create issues using your ' <<
           'OAuth token.'

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

    def self.body_template
      @body_template ||= ERB.new(File.read(
        File.join(
          ErrbitGithubPlugin.root, 'views', 'github_issues_body.txt.erb'
        )
      ))
    end

    def configured?
      errors.empty?
    end

    def url
      '' # TODO
    end

    def errors
      errors = []
      if self.class.fields.detect {|f| options[f[0]].blank? }
        errors << [:base, 'You must specify your GitHub username and password']
      end
      if repo.blank?
        errors << [:base, 'You must specify your GitHub repository url.']
      end
      errors
    end

    def repo
      options[:github_repo]
    end

    def create_issue(title, body, user: {})
      if user['github_login'] && user['github_oauth_token']
        github_client = Octokit::Client.new(
          login: user['github_login'], access_token: user['github_oauth_token'])
      else
        github_client = Octokit::Client.new(
          login: options['username'], password: options['password'])
      end
      issue = github_client.create_issue(repo, title, body)
      issue.html_url
    rescue Octokit::Unauthorized
      raise ErrbitGithubPlugin::AuthenticationError, "Could not authenticate with GitHub. Please check your username and password."
    end
  end
end
