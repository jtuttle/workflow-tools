require 'octokit'

module WorkflowTools
  module VersionControlManagement
    class GitHub
      def pull_request(branch_name)
        pull_requests = client.pull_requests(repo_name).select do |pr|
          pr.head.ref == branch_name
        end

        return nil if pull_requests.count == 0
        
        if pull_requests.count > 1
          raise StandardError, "Found multiple pull requests for branch #{branch_name}."
        end

        pull_request = client.pull_request(repo_name, pull_requests.first.number)

        common_pull_request(pull_request)
      end

      def find_or_create_pull_request(issue, parent_branch_name)
        pull_request = pull_request(issue.branch_name)

        if !pull_request.nil?
          say("Found existing pull request: #{pull_request.url}")
          return pull_request
        end
        
        pull_request = client.create_pull_request(
          repo_name,
          parent_branch_name, issue.branch_name,
          issue.title, "Closes ##{issue.number}"
        )

        say("Created new pull request: #{pull_request.url}")
        
        common_pull_request(pull_request)
      end

      private

      def client
        @client ||=
          Octokit::Client.new(access_token: Config.user.github.access_token)
      end

      def repo_name
        @repo_name ||=
          `git remote show origin -n | grep h.URL | sed 's/.*://;s/.git$//'`.strip
      end

      def common_pull_request(pull_request)
        ::WorkflowTools::Common::PullRequest.new(
          pull_request.html_url,
          pull_request.number,
          pull_request.base.ref,
          pull_request.user.login,
          pull_request.mergeable
        )
      end
    end
  end
end
