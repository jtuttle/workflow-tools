module WorkflowTools
  module Command
    class TaskBreakdown
      def self.execute(issue_number, issue_tracking)
        issue = issue_tracking.issue(issue_number)

        task_steps = []
        task_step = nil

        while task_step != ''
          task_step = ask("Next step?")
          task_steps << task_step unless task_step.empty?
        end

        message = "Task breakdown from #{issue_tracking.user} for #{issue.url} (#{issue.title})\n"

        task_steps.each do |step|
          message << "- #{step}\n"
        end
        
        notifier = Slack::Notifier.new(Config.user.slack.webhook_url)
        notifier.ping(message)
      end
    end
  end
end
