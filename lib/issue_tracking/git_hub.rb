require 'octokit'

module WorkflowTools
  module IssueTracking
    class GitHub
      def service_name
        "GitHub"
      end
      
      def user
        client.user.login
      end
      
      def issue(issue_number)
        issue = client.issue(repo_name, issue_number)
        common_issue(issue)
      end
      
      def issues(labels = [], assignee = nil)
        labels ||= []
        
        options = {
          labels: labels.join(','),
          assignee: assignee
        }
        
        client.issues(repo_name, options).map do |issue|
          common_issue(issue)
        end
      end

      def assign_issue(issue_number, assignee)
        begin
          client.update_issue(repo_name, issue_number, { assignee: assignee })
          say("Assigned issue to #{assignee}.")
        rescue Octokit::UnprocessableEntity
          say("Unable to assign issue to #{assignee}.")
        end
      end

      def add_issue_label(issue_number, label)
        client.add_labels_to_an_issue(repo_name, issue_number, [label])
        say("Added label '#{label}'")
      end
      
      def remove_issue_label(issue_number, label)
        begin
          client.remove_label(repo_name, issue_number, label)
          say("Removed label '#{label}'.")
        rescue Octokit::NotFound
          say("Tried to remove label '#{label}' but it was not found.")
        end
      end

      def pull_request(branch_name)
        pull_request = client.pull_requests(repo_name).select do |pr|
          pr.head.ref == branch_name
        end

        common_pull_request(pull_request.first)
      end

      private

      def client
        @client ||=
          Octokit::Client.new(access_token: Config.user.github.access_token)
      end

      def repo_name
        Config.project.github.repo_name
      end

      def common_issue(issue)
        ::WorkflowTools::Common::Issue.new(
          issue.html_url,
          issue.number,
          issue.title,
          issue.assignee ? issue.assignee.login : nil,
          issue.labels.map { |l| l.name }
        )
      end

      def common_pull_request(pull_request)
        ::WorkflowTools::Common::PullRequest.new(
          pull_request.html_url,
          pull_request.number,
          get_issue(pull_request.issue_url.split('/').last)
        )
      end
    end
  end
end
