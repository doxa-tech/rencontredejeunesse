Rails.application.routes.draw do

  mount Adeia::Engine => "/admin/permissions"

  root to: "pages#vitrine"

  get "login", to: "pages#login"
  get "home", to: "pages#index"

  # TEMP
  get "vitrine", to: "pages#vitrine"

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

  post "orders/update", to: "orders#update", constraints: { subdomain: 'uapi' }

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

    namespace :orders do

      resources :rj, only: [:index, :show, :destroy]
      resources :login, only: [:index, :show, :destroy]

    end

  end

  #
  #
  #
end
