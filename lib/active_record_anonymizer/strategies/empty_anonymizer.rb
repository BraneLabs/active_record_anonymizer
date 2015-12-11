module ActiveRecordAnonymizer
  module Strategies
    class EmptyAnonymizer < BaseAnonymizer
      def anonymize
        ""
      end
    end
  end
end
