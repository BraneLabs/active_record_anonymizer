module ActiveRecordAnonymizer
  module PostgreSQL
    module PgTools
      extend self

      def search_path
        ActiveRecord::Base.connection.schema_search_path
      end

      def default_search_path
        @default_search_path ||= %{"$user", public}
      end

      def set_anonymized_search_path(name=ActiveRecordAnonymizer::Anonymizer.default_schema_name)
        path_parts = [name.to_s, "public"]
        ActiveRecord::Base.connection.schema_search_path = path_parts.join(",")
      end

      def restore_default_search_path
        ActiveRecord::Base.connection.schema_search_path = default_search_path
      end
    end
  end
end