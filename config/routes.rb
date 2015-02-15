Rails.application.routes.draw do
  namespace 'v1', defaults: {format: :json}, except: [:new, :edit] do
    resources :users, only: [:create, :update]
  end
end
