module WorkflowTools
  module Command
    class Issues
      def self.execute(opts, issue_tracking)
        issue_tracking.issues.each do |i|
          puts "##{i.number} - #{i.title}#{i.labels.join(', ')}"
        end
      end
    end
  end
end
