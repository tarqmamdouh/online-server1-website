Rails.application.routes.draw do
  devise_for :users ,:controllers =>{:registrations => "user/registrations", :confirmations => "user/confirmations",:passwords => "user/passwords" }
  root 'welcome#index'
  get 'confirmed' , to: 'welcome#confirmed'
  get 'unconfirmed', to: 'welcome#unconfirmed'
  get 'admin/pins', to: 'admin#pins'
  put 'admin/pins', to: 'admin#add_pins'
  get 'admin', to: 'admin#index'
  get 'download' , to: 'welcome#download'
  get '/ranking/uniques',   to: 'ranking#uniques'
  match '/users',   to: 'users#index',   via: 'get'
  match '/characters/:charname',     to: 'users#show',       via: 'get'
  match '/users/:username',     to: 'users#show_u',       via: 'get'
  #put 'users/:username' => 'users#unmark_spam', :as => 'unmark_spam'
  match '/news',   to: 'categories#index',   via: 'get'
  match '/news/:name',   to: 'categories#show',   via: 'get'
  put 'users/:username/mark_spam' => 'users#mark_spam', :as => 'mark_spam'
  put 'users/:username/be_seller' => 'users#be_seller', :as => 'be_seller'
  get 'search_users', to: 'users#search'
  get 'search_chars', to: 'users#search_char'
  get '/user/preferences' , to: 'users#preferences'
  put '/user/preferences' , to: 'users#withdraw_silk'


  resources :articles do
    resources :comments

  end
  resources :categories ,  except: [:destroy, :index ,:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
