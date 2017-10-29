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
    it '#training_duration_total sums the duration of all activities' do
      behavior = create(:behavior)
      behavior.training_activities = [
        create(:training_activity, training_duration: 60),
        create(:training_activity, training_duration: 120)
      ]

      expect(behavior.training_duration_total).to eq(180)
    end

  end
end
