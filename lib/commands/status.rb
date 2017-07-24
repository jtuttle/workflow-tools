module WorkflowTools
  module Command
    class Status
      def self.execute(version_control, issue_tracking)
        issue_number = /\d+$/.match(version_control.current_branch)
        issue = issue_tracking.issue(issue_number)

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
