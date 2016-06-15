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

        if ActiveRecord::Base.connection.respond_to?(:schema_search_path=)
          ActiveRecord::Base.connection.schema_search_path = path_parts
        end
      end

      def restore_default_search_path(options = {})
        if ActiveRecord::Base.connection.respond_to?(:schema_search_path=)
          ActiveRecord::Base.connection.schema_search_path = default_search_path
        end
      end

      def set_transactional_anonymized_search_path(options = {})
        return unless block_given?

        name = options[:connection_name] || ActiveRecordAnonymizer::Anonymizer.default_schema_name
        path_parts = [name.to_s, "public"].join(",")

        ActiveRecord::Base.transaction do
          ActiveRecord::Base.connection.execute("SET LOCAL search_path TO #{path_parts}", 'SCHEMA')
          begin
            yield
          ensure
            ActiveRecord::Base.connection.execute("SET LOCAL search_path TO #{default_search_path}", 'SCHEMA')
          end
        end
      end

      def set_transactional_default_search_path(options = {})
        return unless block_given?

        old_path = search_path

        ActiveRecord::Base.transaction do
          ActiveRecord::Base.connection.execute("SET LOCAL search_path TO #{default_search_path}", 'SCHEMA')
          begin
            yield
          ensure
            ActiveRecord::Base.connection.execute("SET LOCAL search_path TO #{old_path}", 'SCHEMA')
          end
        end
      end
    end
  end
end