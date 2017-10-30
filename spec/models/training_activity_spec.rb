require 'rails_helper'

describe TrainingActivity, type: :model do
  subject do
    TrainingActivity.new(trained_at: Time.current,
                         training_duration: 60,
                         behavior: Behavior.new)
  end

  it { is_expected.to be_valid }

  describe 'validates #trained_at' do
    let(:current_time) { Time.current.strftime('%F %T') }

    before { Timecop.freeze }
    after { Timecop.return }

    it 'can be on or before the current time' do
      subject.trained_at = Time.current
      expect(subject).to be_valid

      subject.trained_at = 1.second.ago
      expect(subject).to be_valid
    end

    it 'cannot be blank' do
      subject.trained_at = nil
      expect(subject).to_not be_valid
      expect(subject.errors['trained_at']).to include("can't be blank")
    end

    it 'cannot be in the future' do
      subject.trained_at = 1.second.from_now
      expect(subject).to_not be_valid
      expect(subject.errors['trained_at'])
        .to include("must be equal to or before #{current_time}")
    end

    it 'must be a properly formatted datetime' do
      subject.trained_at = 'not a date'
      expect(subject).to_not be_valid
      expect(subject.errors['trained_at']).to include('is not a valid datetime')
    end
  end

  describe 'validates #training_duration' do
    it 'can be a positive integer' do
      subject.training_duration = 5
      expect(subject).to be_valid
    end

    it 'cannot be blank' do
      subject.training_duration = nil
      expect(subject).to_not be_valid
      expect(subject.errors['training_duration']).to include("can't be blank")
    end

    it 'must be an integer' do
      subject.training_duration = 1.5
      expect(subject).to_not be_valid
      expect(subject.errors['training_duration']).to include('must be an integer')
    end

    it 'must be a positive integer' do
      subject.training_duration = -5
      expect(subject).to_not be_valid
      expect(subject.errors['training_duration']).to include('must be greater than 0')
    end

    it 'must be greater than 0' do
      subject.training_duration = 0
      expect(subject).to_not be_valid
      expect(subject.errors['training_duration']).to include('must be greater than 0')
    end
  end
end
