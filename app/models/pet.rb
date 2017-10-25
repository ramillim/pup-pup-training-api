class Pet < ApplicationRecord
  belongs_to :user
  has_many :behaviors, dependent: :destroy

  validates :name, presence: true
  validate :birth_date_is_not_in_future

  def age_in_days
    (Time.zone.today - birth_date.to_date).to_i
  end

  private

  def birth_date_is_not_in_future
    return unless birth_date
    return if birth_date.to_date < Time.zone.today
    errors.add(:birth_date, 'cannot be in the future')
  end
end
