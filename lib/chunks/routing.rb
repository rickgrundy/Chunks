module ActionDispatch::Routing
  class Mapper

    def chunks_routes!(prefix="chunks")
      prefix.gsub!("/", "")
      scope "/#{prefix}", :module => "chunks", :as => "chunks" do
        register_chunks_resources
      end
    end
    
    def register_chunks_resources
      resources :pages

      namespace :admin do
        root :to => "home#index", :as => "home"
        resources :pages
        resources :chunks do
          member do
            put :move_higher
            put :move_lower
          end
        end
        resources :users
      end
    end
    
  end
end