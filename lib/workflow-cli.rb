require 'thor'
require 'git'
require 'octokit'
require 'hashie'
require 'highline/import'
require 'pry'

require_relative 'git_helper'
require_relative 'config'

class WorkflowCli < Thor
  desc "issues", "Get a list of Github issues."
  option :labels, aliases: "-l", type: :array
  option :assignee, aliases: "-a", type: :string
  def issues
    issues = GitHelper.new.issues(options[:labels], options[:assignee])

    issues.each do |i|
      labels = i.labels.map { |l| l.name }
      labels_str = labels.empty? ? '' : " [#{labels.join(', ')}]"
      puts "##{i.number} - #{i.title}#{labels_str}"
    end
  end
  
  desc "start ISSUE_NUMBER", "Creates a branch and marks an issue as in progress."
  option :parent, aliases: "-p", type: :string
  def start(issue_number)
    git = GitHelper.new
    issue = git.get_issue(issue_number)

    git.checkout_and_pull(options[:parent])
    branch_name = git.initialize_branch(issue)

    git.assign_issue(issue_number, git.user.name)
    git.label_issue(issue_number, ["in progress"])

    say("Issue started! You are now working in branch: #{branch_name}")
  end

  desc "status", "Shows a summary of the issue associated with the current branch."
  def status
    git = GitHelper.new
    
    puts git.user.name
    puts Config.project.github.project_name
  end
  
  desc "pull_request", "Creates a pull request without assigning to a reviewer."
  map pr: :pull_request
  def pull_request
    puts "pull request"
  end
  
  desc "code_review", "Creates a pull request, marks an issue as in review, and assigns it to a reviewer."
  map cr: :code_review
  def code_review
    puts "code review"
  end

  desc "complete", "Merges pull request, deletes branch, and closes issue."
  def complete
    puts "complete"
  end
end
