class PatientDifferentPrimaryKeyModel < ActiveRecord::Base
  self.primary_key = "different"

  anonymizes(:name)
end
