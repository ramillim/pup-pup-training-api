Devise.setup do |config|
  # Do not use ActionDispatch::Flash since rails-api does not include it.
  config.navigation_formats = [:json]
end
