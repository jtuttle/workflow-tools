require 'git'

module WorkflowTools
  module VersionControl
    class Git
      ORIGIN = 'origin'
      MASTER = 'master'
      
      def current_branch
        client.current_branch
      end

      def current_issue_number
        /\d+$/.match(current_branch)
      end

      def branch_name_for_issue(issue)
        generate_branch_name(issue)
      end

      def branch_exists?(branch_name)
        client.branches.map(&:name).include?(branch_name)
      end
      
      def checkout_and_pull(branch_name)
        branch_name ||= MASTER
        
        begin
          say(client.checkout(branch_name))
          say(client.pull(ORIGIN, branch_name))
        rescue ::Git::GitExecuteError => e
          binding.pry
          raise StandardError, "Unable to checkout and pull branch: \"#{branch_name}\"."
        end
      end

      def initialize_branch_for_issue(issue)
        branch_name = generate_branch_name(issue)
        say(client.branch(branch_name).checkout)
        say(client.commit("Issue ##{issue.number} Started.", { allow_empty: true }))
        say(client.push(ORIGIN, branch_name))
        say(`git branch --set-upstream-to origin/#{branch_name}`)
        branch_name
      end

      private

      def client
        @client ||= ::Git.init
      end

      def generate_branch_name(issue)
        name = issue.title.downcase.strip.gsub(/[^\w\s]/, '').gsub(/\s+/, '-')
        cutoff = name.index('-', 75) || 100
        "#{name.slice(0, cutoff)}--#{issue.number}"
      end
    end
  end
end
