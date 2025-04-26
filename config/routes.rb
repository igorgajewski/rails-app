Rails.application.routes.draw do
  root "home#index"
  resources :boards, only: [ :index, :show, :destroy, :new, :create ]
end
