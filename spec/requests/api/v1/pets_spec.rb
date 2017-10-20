require 'rails_helper'

describe Api::V1::PetsController, type: :request do
  describe 'GET /api/v1/pets' do
    it 'requires authentication' do
      get api_v1_pets_path
      expect(response).to have_http_status(401)
    end

    it 'works! (now write some real specs)' do
      get api_v1_pets_path
      expect(response).to have_http_status(200)
    end
  end
end
