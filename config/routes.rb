Chunks::Engine.routes.draw do
  root to: "admin/home#index"
  resources :pages
      
  namespace :admin do
    root to: "home#index", as: "home"
    resources :users        
    resources :pages 
    resources :chunks do
      collection do
        post :preview
      end
      member do
        post :share
        get :include
      end
    end
    resources :shared_chunks
  end
end