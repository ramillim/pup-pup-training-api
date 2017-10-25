require 'rails_helper'

describe Behavior, type: :model do
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
