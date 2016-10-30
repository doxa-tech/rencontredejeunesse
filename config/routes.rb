Rails.application.routes.draw do

  root to: "pages#index"

  get "login", to: "pages#login"

  #
  # ORDERS
  #

  %w(confirmed canceled uncertain declined).each do |status|
    get "orders/#{status}", to: "orders##{status}"
  end
  post "orders/update", to: "orders#update"

  namespace :orders do

    resources :rj, only: [:new, :create, :edit, :update] do
      get :confirmation, on: :member
    end

    resources :login, only: [:new, :create, :edit, :update] do
      get :confirmation, on: :member
    end

  end

  #
  #
  #
end
