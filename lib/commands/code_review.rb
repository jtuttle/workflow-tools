module WorkflowTools
  module Command
    class CodeReview
      def self.execute(parent_branch_name, reviewer, issue_tracking, version_control, version_control_management)
        branch = version_control.current_branch
        issue = issue_tracking.issue(branch.issue_number)

        version_control.push(branch.name)
        pull_request =
          version_control_management.find_or_create_pull_request(issue, parent_branch_name)

        if !reviewer.nil?
          issue_tracking.assign_issue(issue.number, reviewer)
        end

        issue_tracking.update_issue_status(issue.number, Config.project.status.review)

        say("Pull request created/updated: #{pull_request.url}")
        `open #{pull_request.url}` if agree("Open in browser?")
      end
    end
  end
end
