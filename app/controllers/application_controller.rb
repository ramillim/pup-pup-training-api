class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def render_json_error(message, code)
    numerical_code = Rack::Utils::SYMBOL_TO_STATUS_CODE[code]
    raise Errors::InvalidHTTPStatusCode if numerical_code.nil?
    message = { errors: { code: numerical_code, message: message } }
    render json: message, status: code
  end

  def render_model_errors(instance, code)
    render_json_error(instance.errors.full_messages.to_sentence, code)
  end

  private

  def parameter_missing(exception)
    render_json_error(exception.message, :bad_request)
  end

  def record_not_found
    render_json_error('404 Not Found', :not_found)
  end

  module Errors
    class InvalidHTTPStatusCode < StandardError
      def message
        'Status code does not exist'
      end
    end
  end
end
