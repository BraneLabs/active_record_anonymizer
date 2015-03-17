module ActiveRecordAnonymizer
  module Strategies
    class NumberAnonymizer < TextAnonymizer
      def base_dictionary
        "1234567890"
      end
    end
  end
end
