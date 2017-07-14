class GitHelper
  def initialize

  end

  def user
    client.user
  end

  private

  def client
    @client ||=
      Octokit::Client.new(access_token: Config::User.github.access_token)
  end
end
