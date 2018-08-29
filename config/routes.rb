Rails.application.routes.draw do
  devise_for :users ,:controllers =>{:registrations => "user/registrations", :confirmations => "user/confirmations",:passwords => "user/passwords" }
  root 'welcome#index'
  get 'welcome/give_time', to: 'welcome#give_time'
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
  put 'users/:username/mark_supp' => 'users#mark_supp', :as => 'mark_supp'
  get 'search_users', to: 'users#search'
  get 'search_chars', to: 'users#search_char'
  get '/user/preferences' , to: 'users#preferences'
  put '/user/preferences' , to: 'users#withdraw_silk'
  get '/user/preferences/resetpassword' , to: 'users#send_reset_password_mail'
  get '/user/preferences/transfer_reward' , to: 'preferences#transfer_reward'
  get '/user/preferences/generate_code' , to: 'preferences#generate_code'
  get '/user/preferences/charge_code' , to: 'preferences#charge_code'
  put 'tickets/:id/close_ticket' => 'tickets#close_ticket', :as => 'close_ticket'
  mount Attachinary::Engine => "/attachinary"
  resources :bugs, except: [:destroy,:edit,:update]
  resources :faq , except: [:show]
  resources :tickets do
    resources :tcomments
  end

  resources :articles do
    resources :comments

  end
  resources :categories ,  except: [:destroy, :index ,:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
