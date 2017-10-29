class Behavior < ApplicationRecord
  belongs_to :pet
  has_many :training_activities, dependent: :destroy

  validates :name, presence: true

  def last_training_time
    training_activities.order(trained_at: :asc).last.try(:trained_at)
  end

  def training_duration_total
    training_activities.sum(:training_duration)
  end
end
