require 'thor'
require 'git'
require 'octokit'
require 'hashie'
require 'highline/import'
require 'pry'

require_relative 'git_helper'
require_relative 'config'

class WorkflowTools < Thor
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

    git.assign_issue(issue_number, git.user.login)
    git.add_label(issue_number, "in progress")
    git.remove_label(issue_number, "ready")

    say("Issue started! You are now working in branch: #{branch_name}")
  end

  desc "status", "Shows a summary of the issue associated with the current branch."
  def status
    git = GitHelper.new

    issue_number = /\d+$/.match(git.current_branch)
    issue = git.get_issue(issue_number)

    str = HighLine.color('Github Issue', :underline)
    str << "\nNumber: #{issue.number}"
    str << "\nTitle: #{issue.title}"
    str << "\nAssignee: #{issue.assignee.login}"
    # TODO: have a standard set of labels so that we can present a status?
    # review, approved, etc
    str << "\nLabels: #{issue.labels.map(&:name).join(', ')}"

    say(str)
  end
  
  desc "pull_request", "Creates a pull request without assigning to a reviewer."
  map pr: :pull_request
  def pull_request
    puts "pull request"
  end
  
  desc "code_review", "Creates a pull request, marks an issue as in review, and assigns it to a reviewer."
  map cr: :code_review
  option :parent, aliases: "-p", type: :string, default: "master"
  option :reviewer, aliases: "-r", type: :string
  def code_review
    git = GitHelper.new

    branch_name = git.current_branch
    issue_number = /\d+$/.match(branch_name)
    issue = git.get_issue(issue_number)

    git.push(branch_name)
    pr_link = git.find_or_create_pull_request(issue, branch_name, options[:parent])
                
    # TODO: can't seem to set the reviewer through octokit (doh!) so just set assignee
    if !options[:reviewer].nil?
      git.assign_issue(issue_number, options[:reviewer])
      pr_issue = git.pull_request_issue(branch_name)
      binding.pry
      git.assign_issue(pr_issue.number, options[:reviewer])
    end
    
    # TODO: This gets done automatically by Waffle, but we shouldn't assume that
    # for general use...let's see what happens!
    git.remove_label(issue_number, "in progress")
    git.add_label(issue_number, "review")
    
    say("Pull request created/updated: #{pr_link}")
    `open #{pr_link}` if agree("Open in browser?")
  end

  desc "revise", "Assign back to the person implementing the story."
  def review
    # Might need some guesswork here because github doesn't track original assignee explicitly
    puts "revise"
  end

  # TODO: This assumes the implementor merges the story, which is not always the case.
  desc "approve", "Label the issue as approved and assign it back to the implementor."
  def approve
    puts "approve"
  end

  desc "complete", "Merges pull request, deletes branch, and closes issue."
  def complete
    puts "complete"
  end
end
