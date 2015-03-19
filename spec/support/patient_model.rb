class PatientModel < ActiveRecord::Base
  anonymizes(:first_name)
  anonymizes(:birth_date, strategy: "BirthDateAnonymizer")
  anonymizes(:phone, strategy: "NumberAnonymizer")
  anonymizes(:email, strategy: "EmailAnonymizer", domain: "fakedomain.com")
end
