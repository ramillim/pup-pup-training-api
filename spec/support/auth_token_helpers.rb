module AuthTokenHelpers
  def get_auth_token(user)
    auth_response_headers = sign_in(user)
    {
      'HTTP_ACCEPT': 'application/json',
      'access-token': auth_response_headers['access-token'],
      client: auth_response_headers['client'],
      expiry: auth_response_headers['expiry'],
      uid: auth_response_headers['uid']
    }
  end

  def sign_in(user)
    user_params = { email: user.email, password: user.password }
    post api_v1_user_session_path, params: user_params
    response.header
  end
end