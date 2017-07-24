class GitHelper

  def current_branch
    git.current_branch
  end





  def checkout(branch_name)
    branch = git.branches.to_a.detect { |br| br.name == branch_name }

    begin
      if branch.remote
        `git checkout -t origin/#{branch.name}`
      else
        branch.checkout
      end
      say("Checked out branch: #{branch}.")
    rescue NoMethodError
      raise ArgumentError, "Could not find branch: #{branch}."
    end
  end
  




  def push(branch_name)
    say(git.push('origin', branch_name))
  end




  def pull_request(branch_name)
    pull_request = github.pull_requests(repo_name).select do |pr|
      pr.head.ref == branch_name
    end

    pull_request.first
  end

  def create_pull_request(branch_name, base, issue) #title, body)
    return if pull_request_link(branch_name)

    pr = github.create_pull_request_for_issue(repo_name, base, branch_name, issue.number)
    pr._links.html.href
  end

  def find_or_create_pull_request(issue, branch_name, parent)
    pr = pull_request_link(branch_name)

    if pr.nil?
      pr = create_pull_request(branch_name, parent, issue) #issue.title, issue.html_url)
    end

    pr
  end

  private

  def github
    @github ||=
      Octokit::Client.new(access_token: Config.user.github.access_token)
  end

  def git
    @git ||= Git.init
  end

  def repo_name
    Config.project.github.repo_name
  end


end
