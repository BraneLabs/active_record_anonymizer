module ActiveRecordAnonymizer
  class Railtie < Rails::Railtie
    rake_tasks do
      import "tasks/views.rake"
    end
  end
end
