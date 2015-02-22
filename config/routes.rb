Rails.application.routes.draw do
  namespace 'v1', defaults: {format: :json}, except: [:new, :edit] do
    get '/authorize', to: 'sessions#authorize', as: 'authorize'
    post '/login', to: 'sessions#create', as: 'login'
    resources :users, only: [:create, :update]
  end
end
