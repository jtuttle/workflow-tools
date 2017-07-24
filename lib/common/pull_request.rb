module WorkflowTools
  module Common
    class PullRequest
      attr_accessor :url, :number, :issue
         
      def initialize(url, number, issue)
        @url = url
        @number = number
        @issue = issue
      end
    end
  end
end
