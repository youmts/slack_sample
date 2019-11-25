Rails.application.routes.draw do
  root to: 'slack#index'

  resources :slack do
    collection do
      get :auth
    end
  end

  get 'auth/slack_user/callback' => 'slack#user_callback'
  get 'auth/slack_admin/callback' => 'slack#admin_callback'
end
