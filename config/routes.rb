Rails.application.routes.draw do

  root to: "pages#index"

  #
  # ORDERS
  #

  namespace :orders do

    resources :rj, only: [:new, :create] do
      get :confirmation, on: :collection
    end

  end

  #
  #
  #
end
