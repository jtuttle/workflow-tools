require 'git'

module WorkflowTools
  module VersionControl
    class Git
      def current_branch
        client.current_branch
      end

      private

      def client
        @client ||= ::Git.init
      end
    end
  end
end
