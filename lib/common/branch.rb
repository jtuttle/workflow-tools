module WorkflowTools
  module Common
    class Branch
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def issue_number
        /\d+$/.match(@name).to_s.to_i
      end
    end
  end
end
