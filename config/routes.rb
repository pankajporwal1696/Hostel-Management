Rails.application.routes.draw do
  resources :users, only: [:create] do
    collection do
      post 'sign_up', to: 'users#create'
      post :login
      delete :logout
    end
  end

  resources :hostels, only: [:index, :create, :update, :destroy] do
    resources :rooms, only: [:index, :create]
  end

  resources :rooms, only: [:update, :destroy] do
    get :search, on: :collection
    resources :bookings, only: [:create]
  end

  resources :bookings, only: [:index, :destroy] do
    member do
      put :approve
      put :reject
    end
  end

  root to: "hostels#index"
end
