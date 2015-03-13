module ActiveRecordAnonymizer
  module Strategies
    class TextAnonymizer
      def self.anonymize(table_name, column_name, options = {})
        base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZCáéíóúÁÉÍÓÚçÇãÃõÕ"
        adapter = ActiveRecord::Base.connection.instance_values["config"][:adapter]
        case adapter
        when "postgresql"
          "translate((#{table_name}.#{column_name})::text, '#{base}'::text, '#{generate_mapping(base)}'::text)"
        else
          raise "#{self.name} not implemented for #{adapter}"
        end
      end

      private
      def self.generate_mapping(base)
        upper = ("A".."Z").to_a
        lower = ("a".."z").to_a
        result = base.split("").map do |letter|
          letter == letter.upcase ? upper.sample : lower.sample
        end
        result.join("")
      end
    end
  end
end
