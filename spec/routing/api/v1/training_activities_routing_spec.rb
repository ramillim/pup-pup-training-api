require 'rails_helper'

describe Api::V1::TrainingActivitiesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/behaviors/1/training_activities')
        .to route_to('api/v1/training_activities#index', behavior_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/training_activities/1')
        .to route_to('api/v1/training_activities#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/behaviors/1/training_activities')
        .to route_to('api/v1/training_activities#create', behavior_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/training_activities/1')
        .to route_to('api/v1/training_activities#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/training_activities/1')
        .to route_to('api/v1/training_activities#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/training_activities/1')
        .to route_to('api/v1/training_activities#destroy', id: '1')
    end
  end
end
