require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    def render_json_error_unauthorized
      render_json_error('An error message', :unauthorized)
    end

    def render_json_error_invalid_code
      render_json_error('An error message', :raise_an_error)
    end

    def render_model_errors_bad_request
      nameless_pet = Pet.create(user: User.create)
      render_model_errors(nameless_pet, :bad_request)
    end
  end

  describe '#render_json_error' do
    before do
      routes.draw do
        get 'render_json_error_unauthorized' =>
              'anonymous#render_json_error_unauthorized'

        get 'render_json_error_invalid_code' =>
              'anonymous#render_json_error_invalid_code'
      end
    end

    it 'renders a given error message and status code symbol' do
      get :render_json_error_unauthorized

      expect(response).to have_http_status(:unauthorized)
      expect(json['errors']['code']).to eq(401)
      expect(json['errors']['message']).to eq('An error message')
    end

    it 'raises an error if an invalid status code is used' do
      expect { get :render_json_error_invalid_code }
        .to raise_error(ApplicationController::Errors::InvalidHTTPStatusCode,
                        'Status code does not exist')
    end
  end

  describe '#render_model_errors' do
    before do
      routes.draw do
        get 'render_model_errors_bad_request' =>
              'anonymous#render_model_errors_bad_request'
      end
    end

    it 'renders the ActiveRecord errors for a model instance' do
      get :render_model_errors_bad_request

      expect(response).to have_http_status(:bad_request)
      expect(json['errors']['code']).to eq(400)
      expect(json['errors']['message']).to eq("Name can't be blank")
    end
  end
end
