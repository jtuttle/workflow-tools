module WorkflowTools
  module Common
    class PullRequest
      attr_accessor :url, :number, :base_branch_name, :user_login, :mergeable
         
      def initialize(url, number, base_branch_name, user_login, mergeable)
        @url = url
        @number = number
        @base_branch_name = base_branch_name
        @user_login = user_login
        @mergeable = mergeable
      end
    end
  end
end
