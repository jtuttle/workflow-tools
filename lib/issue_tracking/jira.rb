require 'jira-ruby'

module WorkflowTools
  module IssueTracking
    class Jira
      def service_name
        "Jira"
      end

      def user
        Config.user.jira.username
      end

      def issue(issue_number)
        issue = client.Issue.find(issue_number)
        common_issue(issue)
      end

      def issues(labels, assignee)
        # TODO: can't currently include filters in JQL of Jira request. May need
        # to create our own client or a PR against the client gem to do that.
        
        issues = project.issues

        if !assignee.nil?
          issues.select! do |i|
            !i.assignee.nil? && i.assignee.name == assignee
          end
        end

        if !labels.nil?
          labels.sort!
          
          issues.select! do |i|
            i.labels & labels.sort == labels
          end
        end

        issues.map do |issue|
          common_issue(issue)
        end
      end

      def assign_issue(issue_number, assignee)
        # TODO
      end

      def add_issue_label(issue_number, label)
        # TODO
      end

      def remove_issue_label(issue_number, label)
        # TODO
      end

      def pull_request(branch_name)
        # TODO: oops, this shouldn't really be in the issue tracker!
      end

      def find_or_create_pull_request(issue, parent_branch_name)
        # TODO: oops, this shouldn't really be in the issue tracker!
      end
      
      def close_issue(issue_number)
        # TODO
      end
      
      def project(name)
        # TODO
      end
      
      private

      def project
        @project ||=
          client.Project.find(Config.project.jira.project_name)
      end

      def client
        @client ||=
          JIRA::Client.new(
            username: Config.user.jira.username,
            password: Config.user.jira.password,
            site: Config.user.jira.base_url,
            context_path: '',
            auth_type: :basic,
#            http_debug: true
          )
      end

      def common_issue(issue)
        ::WorkflowTools::Common::Issue.new(
          issue.self,
          issue.key,
          issue.summary,
          issue.assignee ? issue.assignee.name : nil,
          issue.labels
        )
      end
    end
  end
end
