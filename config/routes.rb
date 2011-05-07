Rails.application.routes.draw do |map|
  namespace :chunks do
    resources :pages
  end
end