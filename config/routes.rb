Rails.application.routes.draw do

  # Redirect root to the sign-in page
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  
  # Update to use the custom controller for registrations
  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :links

  get '/l/:slug', to: 'links#redirect_to_large_url'
  post 'l/:slug', to: 'links#redirect_to_large_url_for_private_links', as: 'redirect_to_large_url_for_private_links'


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
