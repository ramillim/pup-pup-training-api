class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    message = { errors: { code: 404, message: '404 Not Found'} }
    render json: message, status: :not_found
  end
end
