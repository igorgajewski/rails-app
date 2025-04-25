Rails.application.routes.draw do
  resources :boards, only: [ :new, :create, :index, :destroy ] do
    member do
      get "rename"
      patch "update"
    end
  end

  root "home#index"
end
