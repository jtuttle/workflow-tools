module WorkflowTools
  module Command
    class Start
      def self.execute(issue_number, opts, issue_tracking, version_control)
        issue = issue_tracking.issue(issue_number)
        branch_name = version_control.branch_name_for_issue(issue)
        
        if version_control.branch_exists?(branch_name)
          version_control.checkout_and_pull(branch_name)
        else
          version_control.checkout_and_pull(opts[:parent])
          version_control.initialize_branch_for_issue(issue)
        end

        issue_tracking.assign_issue(issue.number, issue_tracking.user)
        issue_tracking.add_issue_label(issue_number, Common::Labels::IN_PROGRESS)
        issue_tracking.remove_issue_label(issue_number, Common::Labels::READY)

        say("Issue started! You are now working in branch: #{branch_name}")        
      end
    end
  end
end
