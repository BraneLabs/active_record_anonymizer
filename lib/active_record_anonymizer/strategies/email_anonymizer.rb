module ActiveRecordAnonymizer
  module Strategies
    class EmailAnonymizer
      attr_reader :table_name, :column_name, :options
      def initialize(table_name, column_name, options = {})
        @table_name = table_name
        @column_name = column_name
        @options = options
      end

      def anonymize
        adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
        case adapter
        when "postgresql"
          name = "#{table_name}.#{column_name}"
          domain = self.options[:domain].presence || "anonymousdomain.com"

          %{
            CASE WHEN ((#{name})::text ~~ '%@%'::text)
            THEN
              (md5(#{name})::text || '@'::text || '#{domain}'::text)
            ELSE
              md5(#{name})::text
            END
          }
        else
          raise "#{self.name} not implemented for #{adapter}"
        end
      end
    end
  end
end
