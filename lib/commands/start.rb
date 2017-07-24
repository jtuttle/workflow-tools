module WorkflowTools
  module Command
    class Start
      def self.execute(opts, issue_tracking, version_control)
        git = GitHelper.new
        issue = git.get_issue(issue_number)

        git.checkout_and_pull(options[:parent])
        branch_name = git.initialize_branch(issue)

        git.assign_issue(issue_number, git.user.login)
        git.add_label(issue_number, "in progress")
        git.remove_label(issue_number, "ready")

        say("Issue started! You are now working in branch: #{branch_name}")        
      end
    end
  end
end
