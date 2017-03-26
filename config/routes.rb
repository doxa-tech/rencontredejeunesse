Rails.application.routes.draw do

  mount Adeia::Engine => "/admin"

  root to: "pages#index"

  get "login", to: "pages#login"

  resources :sessions, only: :create
  delete "signout", to: "sessions#destroy"
  get "signin", to: "sessions#new"

  post "contact", to: "pages#contact"

  # PROFILE
  scope :user do

    get "edit", to: "users#edit"
    patch "update", to: "users#update"

  end

  #
  # ORDERS
  #

  %w(confirmed canceled uncertain declined).each do |status|
    get "orders/#{status}", to: "orders##{status}"
  end

  post "orders/update", to: "orders#update", constraints: { subdomain: 'uapi' }

  get "dashboard", to: "users#index"

  namespace :orders do

    resources :rj, only: [:new, :create, :edit, :update] do
      get :confirmation, on: :member
      post :invoice, on: :member
    end

    # resources :login, only: [:new, :create, :edit, :update] do
    #   get :confirmation, on: :member
    # end

  end

  #
  # ADMIN
  #

  namespace :admin do

    resources :users, except: :show

    namespace :orders do

      resources :rj, only: [:index, :edit, :update, :show, :destroy] do
        get "export", on: :collection
      end
      resources :login, only: [:index, :edit, :update, :show, :destroy]

    end

    resources :checkin, only: [:index, :create, :show]

  end

  #
  # API
  #

  namespace :api do

    resources :posts
    resources :images
    resources :testimonies
    resources :comments
    resources :users do
      post "signin", on: :collection
    end

  end

  #
  #
  #
end
