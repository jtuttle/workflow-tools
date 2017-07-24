module WorkflowTools
  module Command
    class Issues
      def self.execute(opts, issue_tracking)
        issue_tracking.issues(opts[:labels], opts[:assignee]).each do |i|
          labels = "#{i.labels.empty? ? '' : ' [' + i.labels.join(', ') + ']'}"
          assignee = "#{i.assignee.nil? ? '' : ' (' + i.assignee + ')'}"
          puts "##{i.number} - #{i.title}#{labels}#{assignee}"
        end
      end
    end
  end
end
