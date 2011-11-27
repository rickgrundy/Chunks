Chunks::Engine.routes.draw do
  resources :pages
      
  namespace :admin do
    root :to => "home#index", :as => "home"
    resources :users        
    resources :pages  
    resources :chunks do
      collection do
        post :preview
      end
      member do
        post :share
      end
    end
  end
end