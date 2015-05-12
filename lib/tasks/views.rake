namespace :db do
  namespace :anonymizer do
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
      Rails.application.eager_load! if defined?(Rails)

      generated_views = {}
      ActiveRecord::Base.descendants.each do |c|
        if c.respond_to?(:generate_anonymized_view?) && c.generate_anonymized_view? && !generated_views[c.table_name] && ActiveRecord::Base.connection.table_exists?(c.table_name)
          generated_views[c.table_name] = true
          puts "Generating view '#{c.view_name}' for table '#{c.table_name}'"

          ActiveRecord::Base.connection.execute(
            "CREATE OR REPLACE VIEW #{c.view_name} AS " +
            "(SELECT #{c.view_columns.join(', ')} " +
            "FROM #{c.table_name})"
          )
        end
      end
    end
  end
end

Rake::Task["db:migrate"].enhance ["db:anonymizer:create_schema"]

Rake::Task["db:migrate"].enhance do
  Rake::Task["db:anonymizer:generate_views"].invoke
end

Rake::Task["db:rollback"].enhance ["db:anonymizer:remove_schema"]

Rake::Task["db:rollback"].enhance do
  Rake::Task["db:anonymizer:generate_views"].invoke
end