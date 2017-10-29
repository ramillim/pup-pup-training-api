class Behavior < ApplicationRecord
  belongs_to :pet
  has_many :training_activities, dependent: :destroy

  validates :name, presence: true
end
