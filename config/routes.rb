Rails.application.routes.draw do

  mount Adeia::Engine => "/admin"

  root to: "pages#home"

  %w(login privacy application vision).each do |page|
    get page, to: "pages##{page}"
  end

  get "2018", to: redirect('/2019')
  get "2019", to: "pages#rj2019"

  resources :sessions, only: :create
  delete "signout", to: "sessions#destroy"
  get "signin", to: "sessions#new"

  post "contact", to: "pages#contact"

  resources :volunteers, only: [:index, :create]

  #
  # Users
  #

  resources :users, only: [:new, :create], path: "signup" do
    get "success", on: :collection
  end

  namespace :users do

    resources :verification, only: [:new, :edit]
    resources :password_resets, only: [:new, :create, :edit, :update]

  end

  #
  # Connect
  #


  namespace :connect do

    root to: "users#show"
    get "edit", to: "users#edit"
    patch "update", to: "users#update"

    resources :orders, only: [:index, :show] do
      get "pending", on: :collection
    end
    resources :volunteers, only: [:index] do
      post "confirmation", on: :collection
    end

  end

  #
  # ORDERS
  #

  %w(confirmed canceled uncertain declined).each do |status|
    get "orders/#{status}", to: "orders##{status}"
  end

  resources :orders, only: :destroy do
    patch "complete", on: :member
  end

  # postfinance
  post "orders/update", to: "orders#update", constraints: { subdomain: 'uapi' }



  namespace :orders do

    # user update from order
    scope ":id/users", constraints: { id: /\d*/ } do
      get "edit", to: "users#edit", as: "users_edit"
      patch "update", to: "users#update", as: "users_update"
    end

    # sign in/up before order
    scope ":product", constraints: { product: /login|rj/ } do
      resources :users, only: [:new, :create] do
        post "signin", on: :collection
      end
    end

    resources :rj, only: [:new, :create, :edit, :update] do
      get :confirmation, on: :member
    end

    resources :login, only: [:new, :create, :edit, :update] do
      get :confirmation, on: :member
    end

  end

  #
  # ADMIN
  #

  namespace :admin do

    root to: "base#index"

    resources :users, except: :show
    resources :volunteers, except: [:new, :create]
    resources :discounts, except: [:edit, :update]

    namespace :orders do

      resources :rj, only: [:index, :edit, :update, :show, :destroy] do
        get "export", on: :collection
      end
      resources :login, only: [:index, :edit, :update, :show, :destroy]

    end

    resources :checkin, only: [:index, :create, :update, :show]

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
    resources :devices, only: :create
    resources :markers, only: :index

  end

  #
  #
  #
end
