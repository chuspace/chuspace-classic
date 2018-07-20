# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Rails.application.credentials.dig(:github, :client_id), Rails.application.credentials.dig(:github, :secret), scope: 'read:user,user:email,repo,read:org,delete_repo,admin:repo_hook'
end
