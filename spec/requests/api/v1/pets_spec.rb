require 'rails_helper'

describe Api::V1::PetsController, type: :request do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }

  describe 'GET /api/v1/pets' do
    it 'requires authentication' do
      get api_v1_pets_path

      expect(response).to have_http_status(401)
    end

    it 'returns the index for an authenticated user' do
      get api_v1_pets_path, headers: get_auth_token(user)

      expect(response).to have_http_status(200)
      expect(json.first['id']).to eq(pet.id)
    end
  end

  describe 'GET /api/v1/pets/1' do
    it 'requires authentication' do
      get api_v1_pet_path(pet)

      expect(response).to have_http_status(401)
    end

    it 'returns show pet for an authenticated user' do
      get api_v1_pet_path(pet), headers: get_auth_token(user)

      expect(response).to have_http_status(200)
      expect(json['id']).to eq(pet.id)
    end
  end
end
