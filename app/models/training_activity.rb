class TrainingActivity < ApplicationRecord
  belongs_to :behavior

  validates :trained_at, presence: true
  validates_datetime :trained_at, on_or_before: -> { Time.current }

  validates :training_duration, presence: true,
                                numericality: { only_integer: true, greater_than: 0 }
end
