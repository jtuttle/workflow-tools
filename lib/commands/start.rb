module WorkflowTools
  module Command
    class Start
      def self.execute(issue_number, opts, issue_tracking, version_control)
        issue = issue_tracking.issue(issue_number)

        version_control.checkout_and_pull(opts[:parent])
        branch_name = version_control.initialize_branch(issue)

        issue_tracking.assign_issue(issue.number, issue_tracking.user)
        issue_tracking.add_issue_label(issue_number, "in progress")
        issue_tracking.remove_issue_label(issue_number, "ready")

        say("Issue started! You are now working in branch: #{branch_name}")        
      end
    end
  end
end
