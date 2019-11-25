Rails.application.config.middleware.use OmniAuth::Builder do
  provider :slack,
    ENV['SLACK_USER_API_KEY'], ENV['SLACK_USER_API_SECRET'],
    name: :slack_user,
    scope: 'identify,channels:read,channels:history,groups:read,groups:history,search:read'
end