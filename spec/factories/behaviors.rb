FactoryGirl.define do
  factory :behavior do
    association :pet
    name 'Behavior'
    description 'Description'
  end
end
