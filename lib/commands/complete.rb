module WorkflowTools
  module Command
    class Complete
      def self.execute(issue_tracking, version_control, version_control_management)
        branch = version_control.current_branch
        pull_request = version_control_management.pull_request(branch.name)

        if !pull_request.mergeable
          say("Pull request not mergeable. Check for conflicts.")
          return
        end

        unless agree("Are you sure you want to merge #{branch.name} to #{pull_request.base_branch_name}?")
          say("Pull request not merged.")
          return
        end

        version_control.merge(branch.name, pull_request.base_branch_name)
        version_control.push(pull_request.base_branch_name)

        say("Merged #{branch.name} into #{pull_request.base_branch_name}.")

        if agree("Delete remote branch #{branch.name}?")
          version_control.delete_remote_branch(branch.name)
          say("Remote branch deleted.")
        else
          say("Remote branch not deleted.")
        end

        if agree("Delete local branch #{branch.name}?")
          version_control.delete_local_branch(branch.name)
          say("Local branch deleted.")
        else
          say("Local branch not deleted.")
        end

        issue = issue_tracking.issue(branch.issue_number)
        issue_tracking.assign_issue(issue.number, pull_request.user_login)
        
        issue_tracking.close_issue(issue.number)
      end
    end
  end
end
