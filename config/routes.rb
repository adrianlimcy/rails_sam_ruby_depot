Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  #get 'sessions/new'
  #get 'sessions/create'
  #get 'sessions/destroy'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :pay_types
  resources :products do
    get :who_bought, on: :member
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items do
      member do
        put 'decrease'
      end
    end
    resources :carts
    root 'store#index', as: 'store_index', via: :all
    #store_index is rails for store/index
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
