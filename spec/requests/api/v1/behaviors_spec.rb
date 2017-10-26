require 'rails_helper'

describe Api::V1::BehaviorsController, type: :request do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }
  let!(:behavior) { create(:behavior, pet: pet) }

  describe 'GET /api/v1/pets/:pet_id/behaviors' do
    it 'requires authentication' do
      get api_v1_pet_behaviors_path(pet.id)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the index for an authenticated user' do
      get api_v1_pet_behaviors_path(pet.id), headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json.first['id']).to eq(behavior.id)
    end
  end

  describe 'GET /api/v1/behaviors/1' do
    it 'requires authentication' do
      get api_v1_behavior_path(behavior)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns show behavior for an authenticated user' do
      get api_v1_behavior_path(behavior), headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(behavior.id)
      expect(json['name']).to eq(behavior.name)

      # Not serialized properties
      expect(json['behavior_id']).to be_nil
      expect(json['updated_at']).to be_nil
    end

    it 'only shows behaviors that belong to the authenticated user' do
      get api_v1_behavior_path(behavior), headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:forbidden)
      expect(json['errors']['code']).to eq(403)
      expect(json['errors']['message']).to eq('403 Forbidden')
    end

    it 'returns record not found error if record does not exist' do
      get api_v1_behavior_path(0), headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/pets/:pet_id/behaviors' do
    let(:params) do
      { behavior: FactoryGirl.attributes_for(:behavior) }
    end

    it 'requires authentication' do
      post api_v1_pet_behaviors_path(pet.id)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a behavior for an authenticated user' do
      expect do
        post api_v1_pet_behaviors_path(pet.id),
             params: params,
             headers: get_auth_token(user)
      end.to change { Behavior.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(json['name']).to eq(params[:behavior][:name])
    end

    it 'returns an error if the behavior key is missing' do
      post api_v1_pet_behaviors_path(pet.id),
           params: {},
           headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to match(/param is missing/)
    end

    it 'returns an error if the behavior name is blank' do
      params[:behavior][:name] = nil
      post api_v1_pet_behaviors_path(pet.id),
           params: params,
           headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq("Name can't be blank")
    end
  end

  describe 'PUT/PATCH /api/v1/behaviors/1' do
    let(:params) { { id: behavior.id, name: behavior.name } }

    it 'updates a behavior for an authenticated user' do
      new_name = 'Stay'
      params[:name] = new_name
      put api_v1_behavior_path(params[:id]),
          params: { behavior: params },
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['name']).to eq(new_name)
    end

    it 'only updates behaviors that belong to an authenticated user' do
      patch api_v1_behavior_path(params[:id]),
            params: { behavior: params },
            headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:forbidden)
    end

    it 'only updates attributes included in the payload' do
      old_name = params[:name]
      params.delete(:name)
      patch api_v1_behavior_path(params[:id]),
            params: { behavior: params },
            headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['name']).to eq(old_name)
    end

    it 'returns an error if the behavior name is blank' do
      params[:name] = ''
      put api_v1_behavior_path(params[:id]),
          params: { behavior: params },
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq("Name can't be blank")
    end

    it 'returns record not found error if record does not exist' do
      patch api_v1_behavior_path(0), params: {}, headers: user.create_new_auth_token

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/behaviors/1' do
    it 'requires authentication' do
      delete api_v1_behavior_path(behavior)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes a behavior that belongs to an authenticated user' do
      expect do
        delete api_v1_behavior_path(behavior.id),
               headers: get_auth_token(user)
      end.to change { Behavior.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    it 'does not delete a behavior belonging to another user' do
      expect do
        delete api_v1_behavior_path(behavior.id),
               headers: create(:user).create_new_auth_token
      end.to_not change(Behavior, :count)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns a bad request error if the destroy failed' do
      behavior_double = double
      allow(Behavior).to receive(:find).and_return(behavior_double)
      allow(behavior_double).to receive_message_chain(:pet, :user).and_return(user)
      allow(behavior_double).to receive(:destroy).and_return(false)
      allow(behavior_double)
        .to receive_message_chain(:errors, :full_messages, :to_sentence)
        .and_return('Cannot delete')
      delete api_v1_behavior_path(behavior.id), headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq('Cannot delete')
    end

    it 'returns record not found error if record does not exist' do
      delete api_v1_behavior_path(0), headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:not_found)
    end
  end
end
