Rails.application.routes.draw do

  root 'static_pages#top'
  
  get '/signup', to: 'users#new'
  post '/create', to: 'users#create'
  get '/index_result', to: 'users#index_result'
  get 'going_to_work', to: 'users#going_to_work'
  get '/basic_info', to: 'users#basic_info'
  patch '/basic_info_update', to: 'users#basic_info_update'
  
  get '/login', to: 'sessions#new'
  get '/test_login_a', to: 'sessions#general_user_a'
  get '/test_login_b', to: 'sessions#general_user_b'
  get '/test_admin', to: 'sessions#admin_user'
  get '/test_superior_b', to: 'sessions#superior_b_user'
  get '/test_superior_a', to: 'sessions#superior_a_user'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :bases
  
  resources :users do
    collection { post :import}
    member do
      get 'one_week', to: 'users#show_one_week'
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      get 'attendances/overtime_app_index'
      patch 'attendances/overtime_update', to: 'overtimenotifications#overtime_update'
      get 'attendances/edit_app_index'
      patch 'attendances/edit_app', to: 'editnotifications#edit_app'
      patch 'attendances/edit_update', to: 'attendances#edit_update'
      get 'attendances/past_log', to: 'attendances#past_log' 
      post 'attendances/past_log', to: 'attendances#past_log'
      post 'attendances/applicate', to: 'attendancenotifications#new'
      get 'attendances/applicated', to: 'attendancenotifications#index'
      patch 'attendances/applicated', to: 'attendancenotifications#update'
      get 'attendances/output'
    end
    
    resources :attendances do
      patch 'update'
      resources :overtimenotifications
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end