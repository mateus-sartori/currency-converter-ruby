Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout',
                                             registration: 'register' },
                     controllers: {
                       sessions: 'devise_override/sessions',
                       confirmations: 'devise_override/confirmations',
                       registrations: 'devise_override/registrations',
                       passwords: 'devise_override/passwords'
                     }

  post 'validate', to: 'token#validate'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :transactions, only: %i[index create]
    end
  end
end
