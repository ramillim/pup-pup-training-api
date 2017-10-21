require 'rails_helper'

describe Api::V1::PetsController, type: :request do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }

  describe 'GET /api/v1/pets' do
    it 'requires authentication' do
      get api_v1_pets_path

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the index for an authenticated user' do
      get api_v1_pets_path, headers: get_auth_token(user)

      expect(response).to have_http_status(:ok)
      expect(json.first['id']).to eq(pet.id)
    end
  end

  describe 'GET /api/v1/pets/1' do
    it 'requires authentication' do
      get api_v1_pet_path(pet)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns show pet for an authenticated user' do
      get api_v1_pet_path(pet), headers: get_auth_token(user)

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(pet.id)
      expect(json['name']).to eq(pet.name)
      expect(json['birth_date']).to eq(pet.birth_date.strftime('%F'))

      # Not serialized properties
      expect(json['user_id']).to be_nil
    end

    it 'only shows pets that belong to the authenticated user' do
      get api_v1_pet_path(pet), headers: get_auth_token(create(:user))

      expect(response).to have_http_status(:not_found)
      expect(json['errors']['code']).to eq(404)
      expect(json['errors']['message']).to eq('404 Not Found')
    end
  end

  describe 'POST /api/v1/pets/1' do
    let(:pet_params) do
      { pet: FactoryGirl.attributes_for(:pet) }
    end

    it 'requires authentication' do
      post api_v1_pets_path

      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a pet for an authenticated user' do
      expect do
        post api_v1_pets_path, params: pet_params, headers: get_auth_token(user)
      end.to change { Pet.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(json['name']).to eq(pet_params[:pet][:name])
      expect(json['birth_date']).to eq(pet_params[:pet][:birth_date].strftime('%F'))
    end

    it 'returns an error if the pet key is missing' do
      post api_v1_pets_path, params: {}, headers: get_auth_token(user)

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to match(/param is missing/)
    end

    it 'returns an error if the pet name is blank' do
      pet_params[:pet][:name] = nil
      post api_v1_pets_path, params: pet_params, headers: get_auth_token(user)

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq("Name can't be blank")
    end
  end

  describe 'PUT /api/v1/pets/1' do
    it 'updates a pet for an authenticated user' do
    end

    it 'only updates pets that belong to an authenticated user' do
    end

    it 'returns an error if the pet name is blank' do
    end
  end
end
