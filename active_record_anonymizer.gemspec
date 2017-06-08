# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_anonymizer/version'

Gem::Specification.new do |spec|
  # For explanations see http://docs.rubygems.org/read/chapter/20
  spec.name          = "active_record_anonymizer"
  spec.version       = ActiveRecordAnonymizer::VERSION
  spec.authors       = ["Daniel Naves de Carvalho"]
  spec.email         = ["daniel@wearebrane.com", "dnaves@caremessage.org"]
  spec.description   = %q{Creates views which allow anonymization of database tables on another postgresql schema}
  spec.summary       = %q{Gem for creating anonymization views.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb', 'lib/**/*.rake']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake",                        ">= 10.4.2"
  spec.add_development_dependency "rspec",                       ">= 3.1"
  spec.add_development_dependency "sqlite3",                     ">= 1.3.10"
  spec.add_development_dependency "rspec-mocks"

  spec.add_dependency "pg",                                      ">= 0.19"
  spec.add_dependency "activesupport",                           ">=  3.2"
  spec.add_dependency "activerecord",                            ">=  3.2"
end
