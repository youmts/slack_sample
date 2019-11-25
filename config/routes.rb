Rails.application.routes.draw do
  root to: 'slack#index'

  resources :slack do
    collection do
      get :auth
    end
  end

  get 'auth/slack_user/callback' => 'slack#user_callback'
end
