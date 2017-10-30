FactoryGirl.define do
  factory :training_activity do
    association :behavior
    name 'Activity'
    notes 'Activity notes'
    duration { rand(1..20) }
    duration_notes ''
    distance { rand(1..20) }
    distance_notes ''
    distraction { rand(0..5) }
    distraction_notes ''
    trained_at { Time.current.iso8601 }
    training_duration { rand(1..20).minutes.to_s }
  end
end
