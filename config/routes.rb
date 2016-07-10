Rails.application.routes.draw do
  namespace :api do
    resources :items, only: [:show] do
      collection do
        post :upload
      end
    end
  end
end
