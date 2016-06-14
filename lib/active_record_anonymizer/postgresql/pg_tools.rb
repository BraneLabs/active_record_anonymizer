module ActiveRecordAnonymizer
  module PostgreSQL
    module PgTools
      extend self

      def search_path
        ActiveRecord::Base.connection.execute("show search_path").first["search_path"]
      end

      def default_search_path
        @default_search_path ||= %{"$user", public}
      end

      def set_anonymized_search_path(options = {})
        name = options[:connection_name] || ActiveRecordAnonymizer::Anonymizer.default_schema_name

        path_parts = [name.to_s, "public"].join(",")

        if options[:local_transaction_values]
          ActiveRecord::Base.connection.execute("SET LOCAL search_path TO #{path_parts}", 'SCHEMA')
        elsif ActiveRecord::Base.connection.respond_to?(:schema_search_path=)
          ActiveRecord::Base.connection.schema_search_path = path_parts
        end
      end

      def restore_default_search_path(options = {})
        if options[:local_transaction_values]
          ActiveRecord::Base.connection.execute("SET LOCAL search_path TO #{default_search_path}", 'SCHEMA')
        elsif ActiveRecord::Base.connection.respond_to?(:schema_search_path=)
          ActiveRecord::Base.connection.schema_search_path = default_search_path
        end
      end
    end
  end
end