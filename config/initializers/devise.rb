Devise.setup do |config|
  # Do not use ActionDispatch::Flash since rails-api does not include it.
  config.navigational_formats = [:json]
end
