namespace :db do
  namespace :anonymizer do
    def switch_environment(new_env, &block)
      original_env = Rails.env

      Rails.env = new_env.to_s
      ActiveRecord::Base.establish_connection new_env.to_sym

      block.call
    ensure
      Rails.env = original_env.to_s
      ActiveRecord::Base.establish_connection original_env.to_sym
    end

    def generate_views
      old_logger = nil
      if defined?(Rails)
        Rails.application.eager_load!
        old_logger_level = Rails.logger.level
        Rails.logger.level = Logger::INFO
      end
      Rake::Task["db:anonymizer:remove_schema"].invoke
      Rake::Task["db:anonymizer:create_schema"].invoke

      generated_views = {}
      ActiveRecord::Base.connection.schema_cache.clear!
      ActiveRecord::Base.descendants.each do |c|
        if c.respond_to?(:generate_anonymized_view?) && c.generate_anonymized_view? && !generated_views[c.table_name] && ActiveRecord::Base.connection.data_source_exists?(c.table_name)
          generated_views[c.table_name] = true
          log = "Generating view '#{c.view_name}' for table '#{c.table_name}'"
          Rails.logger.info log
          puts log

          c.reset_column_information
          ActiveRecord::Base.connection.execute(
            "CREATE OR REPLACE VIEW #{c.view_name} AS " +
            "(SELECT #{c.view_columns.join(', ')} " +
            "FROM #{c.table_name})"
          )
        end
      end

      if defined?(Rails)
        Rails.logger.level = old_logger_level
      end
    end

    namespace :test do
      desc "Generate the views on the test database"
      task :generate_views => :environment do
        switch_environment :test do
          generate_views
        end
      end
    end

    desc "Remove created schema"
    task :remove_schema => :environment do
      ActiveRecord::Base.connection.execute(
        "DROP SCHEMA IF EXISTS #{ActiveRecordAnonymizer::Anonymizer.default_schema_name} CASCADE"
      )
    end

    desc "Creates mandatory schema"
    task :create_schema => :environment do
      ActiveRecord::Base.connection.execute(
        "CREATE SCHEMA IF NOT EXISTS #{ActiveRecordAnonymizer::Anonymizer.default_schema_name}"
      )
    end

    desc "Generates all the views for the models"
    task :generate_views => :environment do
      generate_views
    end
  end
end


Rake::Task["db:test:prepare"].enhance do
  Rake::Task["db:anonymizer:generate_views"].invoke
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["db:anonymizer:generate_views"].invoke
end

Rake::Task["db:rollback"].enhance do
  Rake::Task["db:anonymizer:generate_views"].invoke
end
