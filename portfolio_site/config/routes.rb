Rails.application.routes.draw do
  # Routes for blog posts
  resources :posts

  # Routes for user sign up
  resources :users, only: [:new, :create]

  # Routes for session management (login/logout)
  get    'login',  to: 'sessions#new'
  post   'login',  to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # Root route displays the list of posts
  root 'posts#index'
end