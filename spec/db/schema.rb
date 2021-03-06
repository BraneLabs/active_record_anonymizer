ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define do
  drop_table :patient_models, if_exists: true
  drop_table :patient_different_primary_key_models, if_exists: true

  create_table :patient_models, id: false do |t|
    t.string :first_name
    t.date   :birth_date
    t.string :gender
    t.string :phone
  end

  create_table :patient_different_primary_key_models, id: false do |t|
    t.string :name
  end
end
