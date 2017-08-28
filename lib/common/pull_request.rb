module WorkflowTools
  module Common
    class PullRequest
      attr_accessor :url, :number, :issue_number, :mergeable
         
      def initialize(url, number, issue_number, mergeable)
        @url = url
        @number = number
        @issue_number = issue_number
        @mergeable = mergeable
      end
    end
  end
end
