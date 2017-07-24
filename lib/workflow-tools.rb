require 'thor'
require 'hashie'
require 'highline/import'
require 'pry'

require_relative 'common/issue'
require_relative 'commands/issues'
require_relative 'commands/status'
require_relative 'commands/start'
require_relative 'issue_tracking/git_hub'
require_relative 'version_control/git'
require_relative 'git_helper'
require_relative 'config'

module WorkflowTools
  class WorkflowTools < Thor
    desc "issues", "Get a list of issues that can be filtered by label and assignee."
    option :labels, aliases: "-l", type: :array
    option :assignee, aliases: "-a", type: :string
    def issues
      Command::Issues.execute(options, issue_tracking)
    end

    desc "status", "Shows a summary of the issue associated with the specified or current branch."
    option :issue_number, aliases: "-i", type: :numeric
    def status
      Command::Status.execute(options, version_control, issue_tracking)
    end
    
    desc "start ISSUE_NUMBER", "Creates a branch and marks an issue as in progress."
    option :parent, aliases: "-p", type: :string
    def start(issue_number)
      Command::Start.execute(issue_number, options, issue_tracking, version_control)
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

    private

    # TODO: Temporarily hard-coding these. We will want them to be configurable.
    def version_control
      VersionControl::Git.new
    end
    
    def issue_tracking
      IssueTracking::GitHub.new
    end
  end
end
