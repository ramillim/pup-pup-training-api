require 'rails_helper'

describe TrainingActivity, type: :model do
  describe 'Creating a new TrainingActivity' do
    subject do
      TrainingActivity.new(trained_at: Time.current,
                           training_duration: 60,
                           behavior: Behavior.new)
    end

    it { is_expected.to be_valid }
  end

  describe '#trained_at' do
    subject { TrainingActivity.new }

    it 'is required' do
      subject.valid?

      expect(subject.errors['trained_at']).to include("can't be blank")
    end

    it 'cannot be in the future' do
      subject.trained_at = 3.days.from_now
      subject.valid?

      expect(subject.errors['trained_at']).to include("cannot be in the future")
    end
  end
end
