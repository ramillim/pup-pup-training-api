require 'rails_helper'

describe Behavior, type: :model do
  describe 'validations' do
    it 'creates a valid Behavior' do
      pet = Pet.new
      behavior = Behavior.new(name: 'Sit', pet: pet)

      expect(behavior).to be_valid
      expect(behavior.pet).to eq(pet)
    end

    it 'validates the presence of a name' do
      behavior = Behavior.new

      expect(behavior).to_not be_valid
      expect(behavior.errors.messages[:name]).to include("can't be blank")
    end

    it 'validates that the record belongs to a pet' do
      behavior = Behavior.new(name: 'Sit')

      expect(behavior).to_not be_valid
      expect(behavior.errors.messages[:pet]).to include('must exist')
    end
  end

  describe 'TrainingActivity calculations' do
    let(:behavior) { create(:behavior) }

    it '#training_duration_total sums the duration of all activities' do
      behavior.training_activities = [
        create(:training_activity, training_duration: 60),
        create(:training_activity, training_duration: 120)
      ]

      expect(behavior.training_duration_total).to eq(180)
    end

    it '#last_training_time returns the last time the behavior was trained' do
      newest_activity = create(:training_activity, trained_at: 2.days.ago)
      behavior.training_activities = [
        create(:training_activity, trained_at: 4.days.ago),
        newest_activity,
        create(:training_activity, trained_at: 3.days.ago)
      ]

      expect(behavior.last_training_time)
        .to be_within(1.second).of newest_activity.trained_at
      # ActiveRecord time precision is greater than DB precision, which only
      # goes out to 6 decimal points.
    end

    it '#last_training_time returns nil if there are no activities' do
      expect(behavior.last_training_time).to be_nil
    end
  end
end
