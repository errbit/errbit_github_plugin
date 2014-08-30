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
      :username => {
        :placeholder => "Your username on GitHub"
      },
      :password => {
        :placeholder => "Password for your account"
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

    attr_accessor :oauth_token
    attr_reader :url

    def configured?
      project_id.present?
    end

    def comments_allowed?; false; end

    def project_id
      app.github_repo
    end

    def errors
      errors = []
      if self.class.fields.detect {|f| params[f[0]].blank? }
        errors << [:base, 'You must specify your GitHub username and password']
      end
      errors
    end

    def github_client
      # Login using OAuth token, if given.
      if oauth_token
        Octokit::Client.new(
          :login => params['username'], :oauth_token => oauth_token)
      else
        Octokit::Client.new(
          :login => params['username'], :password => params['password'])
      end
    end

    def create_issue(problem, reported_by = nil)
      begin
        issue = github_client.create_issue(
          project_id,
          "[#{ problem.environment }][#{ problem.where }] #{problem.message.to_s.truncate(100)}",
          self.class.body_template.result(binding).unpack('C*').pack('U*')
        )
        @url = issue.html_url
        problem.update_attributes(
          :issue_link => issue.html_url,
          :issue_type => self.class.label
        )

      rescue Octokit::Unauthorized
        raise ErrbitGithubPlugin::AuthenticationError, "Could not authenticate with GitHub. Please check your username and password."
      end
    end
  end
end
