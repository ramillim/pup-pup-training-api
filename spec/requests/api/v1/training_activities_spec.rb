require 'rails_helper'

describe Api::V1::TrainingActivitiesController, type: :request do
  let!(:user) { create(:user) }
  let!(:pet) { create(:pet, user: user) }
  let!(:behavior) { create(:behavior, pet: pet) }
  let!(:activity) { create(:training_activity, behavior: behavior) }

  describe 'GET /api/v1/behaviors/:behavior_id/training_activities' do
    it 'requires authentication' do
      get api_v1_behavior_training_activities_path(behavior)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns the index for an authenticated user' do
      get api_v1_behavior_training_activities_path(behavior),
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json.first['id']).to eq(activity.id)
    end
  end

  describe 'GET /api/v1/training_activities/1' do
    it 'requires authentication' do
      get api_v1_training_activity_path(activity)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns show training activity for an authenticated user' do
      get api_v1_training_activity_path(activity),
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(activity.id)
      expect(json['name']).to eq(activity.name)

      # Not serialized properties
      expect(json['behavior_id']).to be_nil
      expect(json['updated_at']).to be_nil
    end

    it 'serializes datetime values in ISO8601 format' do
      get api_v1_training_activity_path(activity),
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['trained_at']).to eq(activity.trained_at.iso8601)
    end

    it 'only shows training activities that belong to the authenticated user' do
      get api_v1_training_activity_path(activity),
          headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:forbidden)
      expect(json['errors']['code']).to eq(403)
      expect(json['errors']['message']).to eq('403 Forbidden')
    end

    it 'returns record not found error if record does not exist' do
      get api_v1_training_activity_path(0),
          headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/behaviors/:behavior_id/training_activities' do
    let(:params) do
      { training_activity: FactoryGirl.attributes_for(:training_activity) }
    end

    it 'requires authentication' do
      post api_v1_behavior_training_activities_path(behavior)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a training activity for an authenticated user' do
      expect do
        post api_v1_behavior_training_activities_path(behavior),
             params: params,
             headers: get_auth_token(user)
      end.to change { TrainingActivity.count }.by(1)

      expect(response).to have_http_status(:created)
      expect(json['name']).to eq(params[:training_activity][:name])
    end

    it 'returns an error if the training_activity key is missing' do
      post api_v1_behavior_training_activities_path(behavior),
           params: {},
           headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to match(/param is missing/)
    end

    it 'returns an error if a required field is blank' do
      params[:training_activity][:trained_at] = nil
      post api_v1_behavior_training_activities_path(behavior),
           params: params,
           headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to match(/Trained at can't be blank/)
    end
  end

  describe 'PUT/PATCH /api/v1/training_activities/1' do
    let(:params) do
      {
        id: activity.id,
        training_activity: FactoryGirl.attributes_for(:training_activity)
      }
    end

    it 'updates a training activity for an authenticated user' do
      new_time = Time.current
      params[:training_activity][:trained_at] = new_time
      put api_v1_training_activity_path(params[:id]),
          params: params,
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['trained_at']).to eq(new_time.iso8601)
    end

    it 'only updates training activities belonging to an authenticated user' do
      patch api_v1_training_activity_path(params[:id]),
            params: params,
            headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:forbidden)
    end

    it 'only updates attributes included in the payload' do
      old_name = params[:training_activity][:name]
      params[:training_activity].delete(:name)
      patch api_v1_training_activity_path(params[:id]),
            params: params,
            headers: user.create_new_auth_token

      expect(response).to have_http_status(:ok)
      expect(json['name']).to eq(old_name)
    end

    it 'returns an error if a required parameter is blank' do
      params[:training_activity][:training_duration] = ''
      put api_v1_training_activity_path(params[:id]),
          params: params,
          headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to match(/Training duration can't be blank/)
    end

    it 'returns record not found error if record does not exist' do
      patch api_v1_training_activity_path(0),
            params: {},
            headers: user.create_new_auth_token

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/training_activities/1' do
    it 'requires authentication' do
      delete api_v1_training_activity_path(activity)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'deletes a training activity that belongs to an authenticated user' do
      expect do
        delete api_v1_training_activity_path(activity),
               headers: get_auth_token(user)
      end.to change { TrainingActivity.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    it 'does not delete a training activity belonging to another user' do
      expect do
        delete api_v1_training_activity_path(activity),
               headers: create(:user).create_new_auth_token
      end.to_not change(TrainingActivity, :count)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns a bad request error if the destroy failed' do
      activity_double = double
      allow(TrainingActivity).to receive(:find).and_return(activity_double)
      allow(activity_double)
        .to receive_message_chain(:behavior, :pet, :user).and_return(user)
      allow(activity_double).to receive(:destroy).and_return(false)
      allow(activity_double)
        .to receive_message_chain(:errors, :full_messages, :to_sentence)
        .and_return('Cannot delete')
      delete api_v1_training_activity_path(activity),
             headers: user.create_new_auth_token

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['message']).to eq('Cannot delete')
    end

    it 'returns record not found error if record does not exist' do
      delete api_v1_training_activity_path(0), headers: create(:user).create_new_auth_token

      expect(response).to have_http_status(:not_found)
    end
  end
end
