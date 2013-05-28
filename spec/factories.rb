FactoryGirl.define do

  factory :location do
    sequence(:description) { |n| "location #{n}" }
    latitude 11.2
    longitude 11.4
    category "Dumpster"
    user
    after_create do |loc|
      loc.approved = true
      loc.save
    end
  end

  factory :user do
    sequence(:email) { |n| "email#{n}@nowhere.edu" }
    sequence(:username) { |n| "user#{n}" }
    password "something"
  end

  factory :tip do
    sequence(:text) { |n| "tip text #{n}" }
    location
    user
  end

  factory :import do
    sequence(:name) { |n| "data import ##{n}" }
    import_type "import_type"
    credit_line "import_credit_line"
  end

  factory :record do
    sequence(:data_key) { |n| "datakey#{n}" }
    location
  end

end
