module WorkflowTools
  module Command
    class Complete
      def self.execute(issue_tracking, version_control)
        branch = version_control.current_branch
        pull_request = issue_tracking.pull_request(branch.name)
binding.pry
        pull_request.mergeable
      end
    end
  end
end
