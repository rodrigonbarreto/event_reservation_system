Rails.application.routes.draw do


  mount Rswag::Ui::Engine => "/api-docs"

  mount V1::ApiGrape => "api", as: :v1_api

  # namespace :api do
  #   namespace :v1 do
  #     resources :events
  #   end
  # end
end
