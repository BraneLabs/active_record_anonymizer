require "rake"
require "active_record"
require 'active_support'

require "active_record_anonymizer/version"
require "active_record_anonymizer/postgresql/pg_tools.rb"
require "active_record_anonymizer/anonymizer.rb"
require "active_record_anonymizer/strategies/text_anonymizer.rb"
require "active_record_anonymizer/strategies/number_anonymizer.rb"
require "active_record_anonymizer/strategies/email_anonymizer.rb"
require "active_record_anonymizer/strategies/birth_date_anonymizer.rb"

require "rspec/anonymizer/matchers.rb"

if defined? Rails
  require "active_record_anonymizer/railties"
end