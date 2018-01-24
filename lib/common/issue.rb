module WorkflowTools
  module Common
    class Issue
      attr_accessor :url, :number, :title, :assignee, :labels
      
      def initialize(url, number, title, assignee, labels)
        @url = url
        @number = number
        @title = title
        @assignee = assignee
        @labels = labels
      end

      def branch_name
        branch_name = @title.downcase.strip.gsub(/[^\w\s]/, '').gsub(/\s+/, '-')
        cutoff = branch_name.index('-', 75) || 100
        "#{@number}--#{branch_name.slice(0, cutoff)}"
      end
    end
  end
end
