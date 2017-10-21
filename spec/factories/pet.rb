FactoryGirl.define do
  factory :pet do
    association :user
    name 'Rover'
    birth_date { 4.months.ago }
  end
end
