Rails.application.routes.draw do
  root to: 'slack#index'

  resources :slack do
    collection do
      get :auth
    end
  end

  get 'auth/:provider/callback' => 'slack#callback'
end
