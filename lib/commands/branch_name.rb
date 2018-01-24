module WorkflowTools
  module Command
    class BranchName
      def self.execute(issue_number, issue_tracking)
        issue = issue_tracking.issue(issue_number)
        
        say(issue.branch_name)
      end
    end
  end
end
