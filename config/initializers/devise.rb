Devise.setup do |config|
  # Do not use ActionDispatch::Flash since rails-api does not include it.
  config.navigational_formats = [:json]
  config.secret_key = ENV['DEVISE_SECRET_KEY'] if Rails.env.production? || Rails.env.test?
end
