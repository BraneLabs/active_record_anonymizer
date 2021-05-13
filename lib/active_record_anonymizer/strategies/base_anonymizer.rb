module ActiveRecordAnonymizer
  module Strategies
    class BaseAnonymizer
      attr_reader :table_name, :column_name, :options
      def initialize(table_name, column_name, options = {})
        @table_name = table_name
        @column_name = column_name
        @options = options
      end

      protected

      def adapter
        ActiveRecord::Base.connection_db_config.adapter.to_s
      end
    end
  end
end
