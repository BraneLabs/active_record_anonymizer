module RSpec
  module Anonymizer
    module Matchers
      def anonymize(column)
        Anonymize.new(column)
      end

      class Anonymize
        def initialize(column)
          @column = column
        end

        def description
          message = "anonymize #{@column}"
          message += " with #{@expected_strategy}" if @expected_strategy
          message += " domain #{@expected_domain}" if @expected_domain
          message
        end

        def failure_message
          message = "expected #{@expected_model}.#{@column} to be anonymized"
          message += " with #{@expected_strategy}" if @expected_strategy
          message += " domain #{@expected_domain}" if @expected_domain
          message
        end

        def strategy(strategy)
          @expected_strategy = strategy
          self
        end

        def domain(domain)
          @expected_domain = domain
          self
        end

        def matches?(expected_model)
          @expected_model = expected_model.is_a?(Class) ? expected_model : expected_model.class

          @expected_model.anonymized_columns.include?(@column) &&
          (@expected_strategy.nil? || @expected_strategy == @expected_model.anonymized_columns[@column.to_sym][:strategy]) &&
          (@expected_domain.nil? || @expected_domain == @expected_model.anonymized_columns[@column.to_sym][:domain])
        end

        def failure_message_when_negated
          message = "expected #{@expected_model}.#{@column} not to be anonymized"
          message += " with #{@expected_strategy}" if @expected_strategy
          message += " domain #{@expected_domain}" if @expected_domain
          message
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Anonymizer::Matchers
end
