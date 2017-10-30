class TrainingActivity < ActiveModel::Serializer
  attributes :id,
             :name,
             :notes,
             :duration,
             :duration_notes,
             :distance,
             :distance_notes,
             :distraction,
             :distraction_notes,
             :trained_at,
             :training_duration
end
