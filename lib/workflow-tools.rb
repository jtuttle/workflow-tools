require 'thor'
require 'hashie'
require 'highline/import'
require 'pry'
require 'slack-notifier'

require_relative 'config'

Dir[__dir__ + '/**/*.rb'].each {|file| require file }

module WorkflowTools
  class WorkflowTools < Thor
    desc "issues", "Get a list of issues that can be filtered by label and assignee."
    option :labels, aliases: "-l", type: :array
    option :assignee, aliases: "-a", type: :string
    def issues
      Command::Issues.execute(options[:labels], options[:assignee], issue_tracking)
    end

    desc "status", "Shows a summary of the issue associated with the specified or current branch."
    option :issue_number, aliases: "-i", type: :numeric
    def status
      Command::Status.execute(options[:issue_number], version_control, issue_tracking)
    end

    desc "task_breakdown", "Posts a task breakdown to a Slack channel."
    map tb: :task_breakdown
    def task_breakdown(issue_number)
      Command::TaskBreakdown.execute(issue_number, issue_tracking)
    end

    desc "branch_name", "Generates a branch name for a given issue."
    map bn: :branch_name
    def branch_name(issue_number)
      Command::BranchName.execute(issue_number, issue_tracking)
    end
    
    desc "start ISSUE_NUMBER", "Creates a branch and marks an issue as in progress."
    option :parent, aliases: "-p", type: :string
    def start(issue_number)
      Command::Start.execute(issue_number, options[:parent], issue_tracking, version_control)
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
      Command::CodeReview.execute(options[:parent], options[:reviewer],
                                  issue_tracking, version_control,
                                  version_control_management)
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
      Command::Complete.execute(issue_tracking, version_control, version_control_management)
    end

    private

    # TODO: Temporarily hard-coding these. We will want them to be configurable.
    def version_control
      VersionControl::Git.new
    end

    def version_control_management
      VersionControlManagement::GitHub.new
    end
    
    def issue_tracking
      #IssueTracking::GitHub.new
      IssueTracking::Jira.new
    end
  end
end
