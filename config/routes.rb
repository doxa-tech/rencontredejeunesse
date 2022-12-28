Rails.application.routes.draw do

  mount Adeia::Engine => "/admin"

  root to: redirect('https://rencontredejeunesse.ch')

  resources :sessions, only: :create
  delete "signout", to: "sessions#destroy"
  get "signin", to: "sessions#new"

  scope "order_bundles/:key" do
    resources :option_orders, only: [:new, :create]
  end

  scope ":key" do
    resources :forms, only: [:new, :create]
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

    resources :refunds, only: :create

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
    # complete the order and proceed to payment
    post "pay", on: :member

    %w(success failed).each do |status|
      get "#{status}", on: :collection
    end
  end
    
  namespace :orders do

    # postfinance
    post "state_update", to: "webhooks#state_update"

    # complete free or invoice order
    resources :completion, only: :update, controller: :completion

    resources :payments, only: [:show] do
      post "pay", on: :member
    end

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

      # Order from a bundle
      resources :bundles, only: [:new, :edit, :update] do
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

    resources :volunteers, only: [:index, :show]
    resources :badges, only: [:index, :create] do
      get "volunteer", on: :collection
      get "prayer", on: :collection
    end
    resources :option_orders
    resources :items

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

    namespace :forms do

      resources :completed_forms, only: [:index, :show, :destroy]

    end

  end

end
