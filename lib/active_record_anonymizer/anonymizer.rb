module ActiveRecordAnonymizer
  module Anonymizer
    extend ActiveSupport::Concern
    def self.default_schema_name
      "anonymized_schema"
    end

    included do
      self.primary_key = "id"
    end

    module ClassMethods
      def generate_anonymized_view?
        @generate_anonymized_view || false
      end

      def view_name
        @view_name || "#{ActiveRecordAnonymizer::Anonymizer.default_schema_name}.#{table_name}"
      end

      def anonymized_columns
        @anonymized_columns || {}
      end

      def view_columns
        @view_columns ||= {}
        default_view_columns.merge(@view_columns)
                            .map{ |k,v| ["#{v} AS #{k}"] }
                            .flatten
      end

      def default_view_columns
        defaults = {}
        column_names.each do |column|
          defaults[column.to_sym] = "#{table_name}.#{column}"
        end
        defaults
      end

      def anonymizes(*attributes)
        @generate_anonymized_view = true
        @view_columns ||= {}
        @anonymized_columns ||= Hash.new({})

        options = attributes.extract_options!.dup
        columns = attributes - [options]

        raise ArgumentError, "You need to supply at least one attribute" if attributes.empty?

        columns.each do |column|
          key = case options[:strategy].to_s.presence
                when nil
                  "ActiveRecordAnonymizer::Strategies::TextAnonymizer"
                when /\AActiveRecordAnonymizer::Strategies::/
                  options[:strategy].to_s
                else
                  "ActiveRecordAnonymizer::Strategies::#{options[:strategy]}"
                end

          begin
            klazz = key.constantize
          rescue NameError
            raise ArgumentError, "Unknown anonymizer: '#{key}'"
          end

          @anonymized_columns[column.to_sym] = (options.presence || {}).merge(strategy: key.sub(/\AActiveRecordAnonymizer::Strategies::/, ""))
          @view_columns[column.to_sym] = klazz.new(table_name, column, options).anonymize
        end
      end
    end
  end
end