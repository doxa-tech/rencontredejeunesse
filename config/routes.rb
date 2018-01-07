Rails.application.routes.draw do

  mount Adeia::Engine => "/admin"

  root to: "pages#home"

  get "login", to: "pages#login"
  get "privacy", to: "pages#privacy"
  get "application", to: "pages#application"
  get "vision", to: "pages#vision"

  resources :sessions, only: :create
  delete "signout", to: "sessions#destroy"
  get "signin", to: "sessions#new"

  post "contact", to: "pages#contact"

  #
  # USERS
  #

  resources :users, only: [:new, :create], path: "signup"

  namespace :users do

    resources :verification, only: [:new, :edit]

  end

  #
  # Connect
  #


  namespace :connect do

    root to: "users#show"
    get "edit", to: "users#edit"
    patch "update", to: "users#update"

    resources :orders, only: [:index, :show]

  end

  #
  # ORDERS
  #

  %w(confirmed canceled uncertain declined).each do |status|
    get "orders/#{status}", to: "orders##{status}"
  end

  post "orders/update", to: "orders#update", constraints: { subdomain: 'uapi' }

  namespace :orders do

    scope ":id/users", constraints: { id: /\d*/ } do
      get "edit", to: "users#edit", as: "users_edit"
      patch "update", to: "users#update", as: "users_update"
    end

    scope ":product", constraints: { product: /login|rj/ } do
      resources :users, only: [:new, :create] do
        post "signin", on: :collection
      end
    end

    # resources :rj, only: [:new, :create, :edit, :update] do
    #   get :confirmation, on: :member
    #   post :invoice, on: :member
    # end

    resources :login, only: [:new, :create, :edit, :update] do
      get :confirmation, on: :member
    end

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

    resources :markers, only: :index

  end

  #
  #
  #
end
