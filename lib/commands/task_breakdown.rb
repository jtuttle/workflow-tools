module WorkflowTools
  module Command
    class TaskBreakdown
      def self.execute(issue_number, issue_tracking)
        issue = issue_tracking.issue(issue_number)

        issue_tracking.update_issue_status(issue_number,
                                           Config.project.status.task_breakdown)
        
        task_steps = []
        task_step = nil

        say("Task breakdown for #{issue_number}: #{issue.title}\n")
        
        while task_step != ''
          task_step = ask("What's the next step?")
          task_steps << task_step unless task_step.empty?
        end

        message = "Task breakdown from *#{issue_tracking.user}* for #{issue.url} (#{issue.title})\n"

        task_steps.each do |step|
          message << "- #{step}\n"
        end

        say("#{message}\n")
        
        agree("Post the above task breakdown to Slack?")        
        
        notifier = Slack::Notifier.new(Config.user.slack.webhook_url)
        notifier.ping(message)

        say("Task breakdown was posted.")
      end
    end
  end
end
