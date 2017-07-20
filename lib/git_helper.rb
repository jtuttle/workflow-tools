class GitHelper
  def initialize

  end

  def user
    github.user
  end

  def current_branch
    git.current_branch
  end

  def get_issue(issue_number)
    github.issue(repo_name, issue_number)
  end
  
  def get_issues(labels, assignee = nil)
    options = {
      labels: labels.nil? ? [] : labels.join(','),
      assignee: assignee
    }
    
    github.issues(repo_name, options)
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
    say(git.push('origin', branch_name))
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
  
  def assign_issue(issue_number, user_name)
    github.update_issue(repo_name, issue_number, { assignee: user_name })
  end

  def label_issue(issue_number, labels)
    github.add_labels_to_an_issue(repo_name, issue_number, labels)
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
