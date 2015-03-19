module ActiveRecordAnonymizer
  module Strategies
    class BirthDateAnonymizer
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

          %{
            CASE WHEN age(patients.birth_date) > '90 years'::interval
            THEN
              '#{90.years.ago.year}-01-01'::date
            ELSE
              (extract(year from #{name}) || '-01-01')::date
            END
          }
        else
          raise "#{self.class.name} not implemented for #{adapter}"
        end
      end
    end
  end
end
