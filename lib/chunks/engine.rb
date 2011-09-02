module Chunks
  class Engine < Rails::Engine
    initializer "chunks static assets" do |app|
      app.middleware.insert_before(Rack::Lock, ActionDispatch::Static, "#{root}/public")
    end    
  end
end