require 'git'

module WorkflowTools
  module VersionControl
    class Git
      ORIGIN = 'origin'
      MASTER = 'master'

      def master_branch
        common_branch(MASTER)
      end
      
      def current_branch
        common_branch(client.current_branch)
      end

      def branch_exists?(branch_name)
        client.branches.map(&:name).include?(branch_name)
      end
      
      def checkout_and_pull(branch_name)
        begin
          say(client.checkout(branch_name))
          say(client.pull(ORIGIN, branch_name))
        rescue ::Git::GitExecuteError => e
          raise StandardError, "Unable to checkout and pull branch: \"#{branch_name}\"."
        end
      end

      def initialize_branch_for_issue(issue)
        branch_name = issue.branch_name
        say(client.branch(branch_name).checkout)
        say(client.commit("Issue ##{issue.number} Started.", { allow_empty: true }))
        say(client.push(ORIGIN, branch_name))
        say(`git branch --set-upstream-to origin/#{branch_name}`)
        branch_name
      end

      def push(branch)
        client.push(ORIGIN, branch.name)
      end

      private

      def client
        @client ||= ::Git.init
      end

      def common_branch(branch_name)
        ::WorkflowTools::Common::Branch.new(
          branch_name
        )
      end
    end
  end
end
