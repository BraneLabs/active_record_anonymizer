Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each  { |file| require file }
require 'active_record'
require 'rspec/mocks'
RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = :expect
  end
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  ActiveRecord::Base.establish_connection(
    adapter: "postgresql",
    database: "active_record_anonymizer"
  )
  require 'db/schema'
end
