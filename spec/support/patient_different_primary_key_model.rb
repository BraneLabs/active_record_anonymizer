class PatientDifferentPrimaryKeyModel < ActiveRecord::Base
  include ActiveRecordAnonymizer::Anonymizer
  self.primary_key = "different"

  anonymizes(:name)
end
