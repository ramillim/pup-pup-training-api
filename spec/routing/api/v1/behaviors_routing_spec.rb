require 'rails_helper'

describe Api::V1::BehaviorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/pets/1/behaviors').to route_to('api/v1/behaviors#index', pet_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/behaviors/1').to route_to('api/v1/behaviors#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/pets/1/behaviors').to route_to('api/v1/behaviors#create', pet_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/api/v1/behaviors/1').to route_to('api/v1/behaviors#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/api/v1/behaviors/1').to route_to('api/v1/behaviors#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/api/v1/behaviors/1').to route_to('api/v1/behaviors#destroy', id: '1')
    end
  end
end
