Rails.application.routes.draw do
  devise_for :users ,:controllers =>{:registrations => "user/registrations", :confirmations => "user/confirmations" }
  root 'welcome#index'
  get 'confirmed' , to: 'welcome#confirmed'
  get 'unconfirmed', to: 'welcome#unconfirmed'
  get 'admin', to: 'welcome#admin'
  get 'download' , to: 'welcome#download'
  match '/users',   to: 'users#index',   via: 'get'
  match '/Characters/:username',     to: 'users#show',       via: 'get'
  match '/users/:username',     to: 'users#show_u',       via: 'get'
  #put 'users/:username' => 'users#unmark_spam', :as => 'unmark_spam'
  put 'users/:username' => 'users#mark_spam', :as => 'mark_spam'
  get 'search_users', to: 'users#search'

  resources :articles do
    resources :comments

  end
  resources :categories ,  except: [:destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
