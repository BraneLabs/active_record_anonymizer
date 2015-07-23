module ActiveRecordAnonymizer
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/views.rake"
    end
  end
end
