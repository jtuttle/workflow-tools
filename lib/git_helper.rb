class GitHelper
  def initialize

  end

  def user
    client.user
  end

  def issues(labels)
    labels ||= []
    client.issues(Config.project.github.project_name, { labels: labels.join(',') })
  end

  private

  def client
    @client ||=
      Octokit::Client.new(access_token: Config.user.github.access_token)
  end
end
