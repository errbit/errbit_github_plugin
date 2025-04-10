# frozen_string_literal: true

describe ErrbitGithubPlugin::IssueTracker do
  describe '.label' do
    it 'return LABEL' do
      expect(described_class.label).to eq described_class::LABEL
    end
  end

  describe '.note' do
    it 'return NOTE' do
      expect(described_class.note).to eq described_class::NOTE
    end
  end

  describe '.fields' do
    it 'return FIELDS' do
      expect(described_class.fields).to eq described_class::FIELDS
    end
  end

  describe '.icons' do

    it 'puts create icon onto the icons' do
      expect(described_class.icons[:create][0]).to eq 'image/png'
      expect(
        described_class.icons[:create][1]
      ).to eq ErrbitGithubPlugin.read_static_file('github_create.png')
    end

    it 'puts goto icon onto the icons' do
      expect(described_class.icons[:goto][0]).to eq 'image/png'
      expect(
        described_class.icons[:goto][1]
      ).to eq ErrbitGithubPlugin.read_static_file('github_goto.png')
    end

    it 'puts inactive icon onto the icons' do
      expect(described_class.icons[:inactive][0]).to eq 'image/png'
      expect(
        described_class.icons[:inactive][1]
      ).to eq ErrbitGithubPlugin.read_static_file('github_inactive.png')
    end
  end

  let(:tracker) { described_class.new(options) }

  describe '#configured?' do
    context 'with errors' do
      let(:options) { { invalid_key: '' } }
      it 'return false' do
        expect(tracker.configured?).to eq false
      end
    end
    context 'without errors' do
      let(:options) do
        { username: 'foo', password: 'bar', github_repo: 'user/repos' }
      end
      it 'return true' do
        expect(tracker.configured?).to eq true
      end
    end
  end

  describe '#url' do
    let(:options) { { github_repo: 'repo' } }
    it 'returns issues url' do
      expect(tracker.url).to eq 'https://github.com/repo/issues'
    end
  end

  describe '#errors' do
    subject { tracker.errors }
    context 'without username' do
      let(:options) { { username: '', password: 'bar', github_repo: 'repo' } }
      it { is_expected.not_to be_empty }
    end
    context 'without password' do
      let(:options) do
        { username: '', password: 'bar', github_repo: 'repo' }
      end
      it { is_expected.not_to be_empty }
    end
    context 'without github_repo' do
      let(:options) do
        { username: 'foo', password: 'bar', github_repo: '' }
      end
      it { is_expected.not_to be_empty }
    end
    context 'with completed options' do
      let(:options) do
        { username: 'foo', password: 'bar', github_repo: 'repo' }
      end
      it { is_expected.to be_empty }
    end
  end

  describe '#repo' do
    let(:options) { { github_repo: 'baz' } }
    it 'returns github repo' do
      expect(tracker.repo).to eq 'baz'
    end
  end

  describe '#create_issue' do
    subject { tracker.create_issue('title', 'body', user: user) }
    let(:options) do
      { username: 'foo', password: 'bar', github_repo: 'user/repos' }
    end
    let(:fake_github_client) do
      double('Fake GitHub Client').tap do |github_client|
        github_client.stub(:create_issue).and_return(fake_issue)
      end
    end
    let(:fake_issue) do
      double('Fake Issue').tap do |issue|
        issue.stub(:html_url).and_return('http://github.com/user/repos/issues/878')
      end
    end

    context 'signed in with token' do
      let(:user) do
        {
          'github_login' => 'bob',
          'github_oauth_token' => 'valid_token'
        }
      end
      it 'return issue url' do
        Octokit::Client.stub(:new).with(
          login: user['github_login'], access_token: user['github_oauth_token']
        ).and_return(fake_github_client)
        expect(subject).to eq fake_issue.html_url
      end
    end

    context 'signed in with password' do
      let(:user) { {} }
      it 'return issue url' do
        (Octokit::Client).stub(:new).with(
          login: options['username'], password: options['password']
        ).and_return(fake_github_client)
        expect(subject).to eq fake_issue.html_url
      end
    end

    context 'when unauthentication error' do
      let(:user) do
        { 'github_login' => 'alice', 'github_oauth_token' => 'invalid_token' }
      end
      it 'raise AuthenticationError' do
        (Octokit::Client).stub(:new).with(
          login: user['github_login'], access_token: user['github_oauth_token']
        ).and_raise(Octokit::Unauthorized)
        expect { subject }.to raise_error
      end
    end
  end
end
