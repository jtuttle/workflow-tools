class GitHelper

  def current_branch
    git.current_branch
  end

  def checkout_and_pull(branch_name)
    begin
      branch_name ||= 'master'
      say(git.checkout(branch_name))
      say(git.pull('origin', branch_name))
    rescue Git::GitExecuteError
      raise StandardError, "Unable to checkout and pull branch: \"#{branch_name}\"."
    end
  end

  def initialize_branch(issue)
    branch_name = generate_branch_name(issue)
    say(git.branch(branch_name).checkout)
    say(git.commit("Issue ##{issue.number} Started.", { allow_empty: true }))
    say(push(branch_name))
    say(`git branch --set-upstream-to origin/#{branch_name}`)
    branch_name
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

  def pull_request_number(branch_name)
    pr = pull_request(branch_name)
    pr.nil? ? nil : pr.number
  end

  def pull_request_link(branch_name)
    pr = pull_request(branch_name)
    pr.nil? ? nil : pr.html_url
  end

  def pull_request_issue(branch_name)
    pr = pull_request(branch_name)
    get_issue(pr.issue_url.split('/').last)
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

  def generate_branch_name(issue)
    name = issue.title.downcase.strip.gsub(/[^\w\s]/, '').gsub(/\s+/, '-')
    cutoff = name.index('-', 75) || 100
    "#{name.slice(0, cutoff)}--#{issue.number}"
  end
end
