class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def parameter_missing(exception)
    message = { errors: { code: 400, message: exception.message } }
    render json: message, status: :bad_request
  end

  def record_not_found
    message = { errors: { code: 404, message: '404 Not Found' } }
    render json: message, status: :not_found
  end
end
