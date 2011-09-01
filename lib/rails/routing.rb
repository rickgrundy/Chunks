module ActionDispatch::Routing
  class Mapper

    def chunks!(prefix)
      scope "/#{prefix.gsub("/", "")}", :module => "chunks" do
        register_chunks_routes
      end
    end
    
    def register_chunks_routes
      resources :pages

      namespace :admin do
        resources :pages
      end
    end
    
  end
end