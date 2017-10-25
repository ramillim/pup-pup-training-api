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

      expect(response).to have_http_status(:forbidden)
      expect(json['errors']['code']).to eq(403)
      expect(json['errors']['message']).to eq('403 Forbidden')
    end

    it 'returns an error if the pet is not found' do
      get api_v1_pet_path(0), headers: get_auth_token(user)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/pets' do
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

  describe 'PUT/PATCH /api/v1/pets/1' do
    let(:params) do
      {
        id: pet.id,
        name: pet.name,
        birth_date: pet.birth_date,
        user_id: user.id
      }
    end

    it 'updates a pet for an authenticated user' do
      new_name = 'Woof'
      params[:name] = new_name
      put api_v1_pet_path(params[:id]),
          params: { pet: params },
          headers: get_auth_token(user)

      expect(response).to have_http_status(:ok)
      expect(json['name']).to eq(new_name)
      expect(json['birth_date']).to eq(params[:birth_date].strftime('%F'))
    end

    it 'only updates pets that belong to an authenticated user' do
      patch api_v1_pet_path(params[:id]),
            params: { pet: params },
            headers: get_auth_token(create(:user))

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns an error if the pet is not found' do
      put api_v1_pet_path(0), headers: get_auth_token(user)

      expect(response).to have_http_status(:not_found)
    end

    it 'only updates attributes included in the payload' do
      old_birth_date = pet.birth_date.strftime('%F')
      new_name = 'Woof'
      params[:name] = new_name
      params.delete(:birth_date)
      patch api_v1_pet_path(params[:id]),
            params: { pet: params },
            headers: get_auth_token(user)

      expect(response).to have_http_status(:ok)
      expect(json['name']).to eq(new_name)
      expect(json['birth_date']).to eq(old_birth_date)
    end

    it 'returns an error if the pet name is blank' do
      params[:name] = ''
      put api_v1_pet_path(params[:id]),
          params: { pet: params },
          headers: get_auth_token(user)

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq("Name can't be blank")
    end
  end

  describe 'DELETE /api/v1/pets/1' do
    it 'requires authentication' do
      delete api_v1_pet_path(pet)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes a pet that belongs to an authenticated user' do
      expect do
        delete api_v1_pet_path(pet.id), headers: get_auth_token(user)
      end.to change { Pet.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    it 'returns an error if the pet is not found' do
      delete api_v1_pet_path(0), headers: get_auth_token(user)

      expect(response).to have_http_status(:not_found)
    end

    it 'does not delete a pet belonging to another user' do
      expect do
        delete api_v1_pet_path(pet.id), headers: get_auth_token(create(:user))
      end.to_not change(Pet, :count)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns a bad request error if the destroy failed' do
      pet_double = double
      allow(Pet).to receive(:find).and_return(pet_double)
      allow(pet_double).to receive(:user).and_return(user)
      allow(pet_double).to receive(:destroy).and_return(false)
      allow(pet_double)
        .to receive_message_chain(:errors, :full_messages, :to_sentence)
        .and_return('Cannot delete')
      delete api_v1_pet_path(pet.id), headers: get_auth_token(user)

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq('Cannot delete')
    end
  end
end
