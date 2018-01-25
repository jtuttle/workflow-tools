module WorkflowTools
  module Command
    class Start
      def self.execute(issue_number, parent_branch, issue_tracking, version_control)
        parent_branch ||= version_control.current_branch

        master_branch = version_control.master_branch

        if parent_branch.name != master_branch.name
          return unless agree("Not currently on #{master_branch.name} branch. Branch off #{parent_branch.name} instead?")
        end
        
        issue = issue_tracking.issue(issue_number)
        branch_name = issue.branch_name
        
        if version_control.branch_exists?(branch_name)
          version_control.checkout_and_pull(branch_name)
        else
          version_control.checkout_and_pull(parent_branch.name)
          version_control.initialize_branch_for_issue(issue)
        end

        issue_tracking.assign_issue(issue.number, issue_tracking.user)
        issue_tracking.update_issue_status(issue.number, Config.project.status.in_progress)

        say("Issue started! You are now working in branch: #{branch_name}")        
      end
    end
  end
end
