FactoryGirl.define do

  factory :location do
    sequence(:description) { |n| "location #{n}" }
    latitude 11.2
    longitude 11.4
    category "Dumpster"
    user
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
end
