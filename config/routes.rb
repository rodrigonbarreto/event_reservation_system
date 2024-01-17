Rails.application.routes.draw do

  # devise_for :users

  namespace :api do
    namespace :v1 do
      resources :events
    end
  end

  post 'session/create'
  delete 'session/destroy'
end
