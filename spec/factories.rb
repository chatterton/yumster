FactoryGirl.define do
  factory :location do
    description "a location"
    latitude 11.2
    longitude 11.4
    category "Dumpster"
  end
  factory :user do
    email "somebody@somewhere.edu"
    username "somebody"
    password "something"
  end
end
