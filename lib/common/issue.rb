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
    end
  end
end
