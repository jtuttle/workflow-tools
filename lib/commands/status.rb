module WorkflowTools
  module Command
    class Status
      def self.execute(issue_number, version_control, issue_tracking)
        issue_number = issue_number || version_control.current_branch.issue_number

        begin
          issue = issue_tracking.issue(issue_number)
        rescue
          say("Issue #{issue_number} not found.")
          return
        end

        str = HighLine.color("#{issue_tracking.service_name} Issue (#{issue.number})", :underline)
        str << "\n#{issue.url}"
        str << "\nTitle: #{issue.title}"
        str << "\nAssignee: #{issue.assignee}"
        # TODO: have a standard set of labels so that we can present a status?
        # review, approved, etc
        str << "\nLabels: #{issue.labels.join(', ')}"

        say(str)
      end
    end
  end
end
