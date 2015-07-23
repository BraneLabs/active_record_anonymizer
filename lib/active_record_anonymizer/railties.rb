module ActiveRecordAnonymizer
  class Railtie < Rails::Railtie
    rake_tasks do
      import "active_record/railties/databases.rake"
      import "tasks/views.rake"
    end
  end
end
