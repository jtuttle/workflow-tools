module WorkflowTools
  module Common
    class PullRequest
      attr_accessor :url, :number, :issue_number
         
      def initialize(url, number, issue_number)
        @url = url
        @number = number
        @issue_number = issue_number
      end
    end
  end
end
