module ActiveRecordAnonymizer
  module Strategies
    class EmailAnonymizer < BaseAnonymizer
      def anonymize
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
        when "nulldb"
          ""
        else
          raise "#{self.class.name} not implemented for #{adapter}"
        end
      end
    end
  end
end
