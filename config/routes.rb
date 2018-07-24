Rails.application.routes.draw do
  devise_for :users ,:controllers =>{:registrations => "user/registrations" }
  root 'welcome#index'
  get 'confirmed' , to: 'welcome#confirmed'
  get 'unconfirmed', to: 'welcome#unconfirmed'
  resources :articles
  resources :categories ,  except: [:destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
