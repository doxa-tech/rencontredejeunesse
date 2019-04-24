Rails.application.routes.draw do

  mount Adeia::Engine => "/admin"

  get "/", to: "pages#resources", constraints: { subdomain: 'ressources' }
  
  root to: "pages#home"
  
  %w(login privacy application vision volunteers highlights resources support).each do |page|
    get page, to: "pages##{page}"
  end

  get "2018", to: "pages#rj2018"
  get "2019", to: "pages#rj2019", as: :rj

  resources :sessions, only: :create
  delete "signout", to: "sessions#destroy"
  get "signin", to: "sessions#new"

  post "contact", to: "pages#contact"

  scope "order_bundles/:key" do
    resources :option_orders, only: [:new, :create]
  end

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

    resources :orders, only: [:index, :show, :invoice, :ticket] do
      get "pending", on: :collection
      member do
        get 'invoice'
        get 'ticket'
      end
    end
    resources :option_orders, only: [:index, :show, :destroy]

  end

  #
  # ORDERS
  #

  resources :orders, only: :destroy do
    %w(confirmed canceled uncertain declined).each do |status|
      get "#{status}", on: :collection
    end
  end
    
  namespace :orders do

    # postfinance
    if Rails.env.production?
      post "postfinance", to: "completion#postfinance", constraints: { subdomain: 'uapi' }
    else
      post "postfinance", to: "completion#postfinance"
    end

    # complete free or invoice order
    resources :completion, only: :update, controller: :completion

    # user update from order
    scope ":id/user", constraints: { id: /\d*/ }, as: :user do
      get "edit", to: "users#edit"
      patch "update", to: "users#update"
    end

    scope "(:key)" do

      # order a ticket for an event
      resources :events, only: [:new, :create, :edit, :update] do
        get "confirmation", on: :member
      end

      # sign in/up before order
      resources :users, only: [:new, :create]

    end

  end

  #
  # ADMIN
  #

  namespace :admin do

    root to: "base#index"

    resources :volunteers, only: [:index, :show] do
      get "badge", on: :collection
      get "badge_volunteer", on: :collection
      get "badge_prayer", on: :collection
    end
    resources :option_orders

    resources :users, except: :show
    resources :discounts, except: [:edit, :update]
    resources :payments, except: [:index, :new]
    resources :testimonies, except: [:show, :new, :create]
    resources :posts
    resources :comments, only: [:edit, :update, :destroy]

    namespace :orders do

      resources :events
      resources :registrants, only: [:index, :show, :update] do
        get "export", on: :collection
      end
      resources :checkin, only: [:index, :create, :update]

    end

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
