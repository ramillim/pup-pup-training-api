class TrainingActivitySerializer < ActiveModel::Serializer
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

  def trained_at
    object.trained_at.try(:iso8601)
  end
end
