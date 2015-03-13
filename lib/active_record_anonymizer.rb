require "rake"
require "active_record"
require 'active_support'

require "active_record_anonymizer/version"
require "active_record_anonymizer/postgresql/pg_tools.rb"
require "active_record_anonymizer/anonymizer.rb"
require "active_record_anonymizer/strategies/text_anonymizer.rb"

load "active_record/railties/databases.rake"
load "tasks/views.rake"