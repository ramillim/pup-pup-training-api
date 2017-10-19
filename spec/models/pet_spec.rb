require 'rails_helper'

describe Pet, type: :model do
  it 'requires a name' do
    invalid_pet = Pet.new

    expect(invalid_pet).to_not be_valid
    expect(invalid_pet.errors.messages[:name]).to include("can't be blank")
  end

  it 'validates a birth_date in the past' do
    valid_pet = Pet.new(name: 'Rover', birth_date: 2.days.ago)

    expect(valid_pet).to be_valid
  end

  it 'validates that birth_date is not in the future' do
    invalid_pet = Pet.new(name: 'Rover', birth_date: 1.day.from_now)

    expect(invalid_pet).to_not be_valid
    expect(invalid_pet.errors.messages[:birth_date])
      .to include('cannot be in the future')
  end

  it 'calculates age in days' do
    birth_date = 45.days.ago
    pet = Pet.new(name: 'Rover', birth_date: birth_date)

    expect(pet.age_in_days).to eq(45)
  end
end
