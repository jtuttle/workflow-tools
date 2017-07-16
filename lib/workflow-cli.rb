require 'thor'
require 'octokit'
require 'hashie'

require_relative 'git_helper'
require_relative 'config'

class WorkflowCli < Thor
  desc "issues", "Get a list of Github issues."
  method_option :labels, for: :issues, type: :array, aliases: "-l", desc: 
  def issues
    git = GitHelper.new

    issues = git.issues(options[:labels])

    issues.each do |i|
      labels = i.labels.map { |l| l.name }
      labels_str = labels.empty? ? '' : " [#{labels.join(', ')}]"
      puts "##{i.number} - #{i.title}#{labels_str}"
    end
  end
  
  desc "start", "Creates a branch and marks a story as in progress."
  def start
    puts "start"
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
  
  desc "code_review", "Creates a pull request, marks a story as in review, and assigns it to a reviewer."
  map cr: :code_review
  def code_review
    puts "code review"
  end

  desc "complete", "Merges pull request, deletes branch, and closes issue."
  def complete
    puts "complete"
  end
end
