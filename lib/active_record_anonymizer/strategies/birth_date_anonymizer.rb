module ActiveRecordAnonymizer
  module Strategies
    class BirthDateAnonymizer < BaseAnonymizer
      def anonymize
        adapter = ActiveRecord::Base.connection_config[:adapter]
        case adapter.to_s
        when "postgresql"
          name = "#{table_name}.#{column_name}"

          %{
            CASE WHEN age(#{name}) > '90 years'::interval
            THEN
              '#{90.years.ago.year}-01-01'::date
            ELSE
              (extract(year from #{name}) || '-01-01')::date
            END
          }
        when "nulldb"
          ""
        else
          raise "#{self.class.name} not implemented for #{adapter}"
        end
      end
    end
  end
end
