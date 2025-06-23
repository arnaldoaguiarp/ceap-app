require 'sidekiq/web'
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_ceap_app_session'

Rails.application.routes.draw do
  if Rails.env.development? || Rails.env.staging?
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      resources :deputies, only: [:index, :show]
      resources :uploads, only: [:create]
    end
  end
end
