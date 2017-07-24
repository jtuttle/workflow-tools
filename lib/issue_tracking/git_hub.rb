require 'octokit'

module WorkflowTools
  module IssueTracking
    class GitHub
      def service_name
        "GitHub"
      end
      
      def user
        client.user
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

      def common_issue(issue)
        ::WorkflowTools::Common::Issue.new(
          issue.html_url,
          issue.number,
          issue.title,
          issue.assignee.login,
          issue.labels.map { |l| l.name }
        )
      end

      def assign_issue(issue_number, assignee)
        say(client.update_issue(repo_name, issue_number, { assignee: assignee }))
      end

      def add_issue_label(issue_number, label)
        client.add_labels_to_an_issue(repo_name, issue_number, [label])
        say("Added label '#{label}'")
      end
      
      def remove_label(issue_number, label)
        begin
          client.remove_label(repo_name, issue_number, label)
          say("Removed label '#{label}'.")
        rescue Octokit::NotFound
          say("Tried to remove label '#{label}' but it was not found.")
        end
      end

      private

      def client
        @client ||=
          Octokit::Client.new(access_token: Config.user.github.access_token)
      end

      def repo_name
        Config.project.github.repo_name
      end
    end
  end
end
