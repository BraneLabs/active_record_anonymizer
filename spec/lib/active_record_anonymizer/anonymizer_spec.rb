require 'spec_helper'

describe ActiveRecordAnonymizer::Anonymizer do
  before do
    allow(ActiveRecord::Base.connection).to receive(:instance_values).and_return({"config" => {adapter: "postgresql"}})
    Dir["./spec/support/*.rb"].each { |f| require f }
  end

  subject(:klass) { PatientModel }

  context "#primary_key" do
    it { expect(PatientModel.primary_key).to eq("id") }
    it { expect(PatientDifferentPrimaryKeyModel.primary_key).to eq("different") }
  end

  context "anonymizes" do
    it { expect(PatientModel).to anonymize(:first_name) }
    it { expect(PatientModel).to anonymize(:birth_date).strategy("BirthDateAnonymizer") }
    it { expect(PatientModel).to anonymize(:email).strategy("EmailAnonymizer").domain("fakedomain.com") }
    it { expect(PatientModel).to anonymize(:phone).strategy("NumberAnonymizer") }
    it { expect(PatientModel).not_to anonymize(:gender) }
  end
end