module WorkflowTools
  module Common
    class Branch
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def issue_number
        split_name = @name.split('--')
        
        if split_name.length < 2
          raise StandardError, "Could not get issue number from branch: #{@name}"
        end
        
        split_name[0]
      end
    end
  end
end
