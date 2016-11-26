Rails.application.routes.draw do

  mount Adeia::Engine => "/admin/permissions"

  root to: "pages#index"

  get "login", to: "pages#login"

  resources :sessions, only: :create
  delete "signout", to: "sessions#destroy"
  get "signin", to: "sessions#new"

  get "dashboard", to: "pages#dashboard"

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

  namespace :admin do

    resources :users, except: :show

    scope :orders do

      resources :rj, controller: :orders, only: [:show, :destroy] do
        get "/", to: "orders#rj", on: :collection
      end
      resources :login, controller: :orders, only: [:show, :destroy] do
        get "/", to: "orders#login", on: :collection
      end

    end

  end

  #
  #
  #
end
