Rails.application.routes.draw do
  #get 'yoteis/edit'
  #get 'yoteis/new'
  
  # ログアウトのルートを追加
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
  
  # deviseの初期化
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # 認証を必要とするルーティング
  authenticate :user do
    resources :users do
      resources :yoteis
      resources :rouzis
    end
    put '/custom_method', to: 'home#custom_method'
  end


  
  # 認証不要のルート
  root to: "home#index"
end