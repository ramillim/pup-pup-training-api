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

  describe 'validates #trained_at' do
    subject { TrainingActivity.new }
    let(:current_time) { Time.current.strftime('%F %T') }

    before { Timecop.freeze }
    after { Timecop.return }

    it 'cannot be blank' do
      subject.valid?

      expect(subject.errors['trained_at']).to include("can't be blank")
    end

    it 'cannot be in the future' do
      subject.trained_at = 1.second.from_now
      subject.valid?

      expect(subject.errors['trained_at'])
        .to include("must be equal to or before #{current_time}")
    end

    it 'can be on or before the current time' do
      subject.trained_at = Time.current
      subject.valid?
      expect(subject.errors['trained_at']).to be_empty

      subject.trained_at = 1.second.ago
      subject.valid?
      expect(subject.errors['trained_at']).to be_empty
    end
  end
end
