BaseApp::Application.routes.draw do

  resources :events, :only => [:index, :show]

  get "groups/members", :as => "members"
  get "groups/activity", :as => "activities"
  get "groups/my_ideas"
  get "groups/all_ideas"
  get "groups/all_my_ideas"
  get "groups/featured"
  get "groups/active"
  get "groups/newest"
  get "groups/default"



  put "groups/set"

  resources :expert_requests, :only => [:new, :create]
  resources :orders, :only => [:new, :create]
  resources :ideas_users, :only => [:update, :destroy]

  get "users/show"

  resources :steps, :only => [:edit, :update]
  resources :ideas do 
    resources :invitations, :only => [:new, :create] do
      get :accept, :on => :member
    end
    member do 
      get "likes"
      put 'vote'
    end
  end
  resources :profiles, :only => [:show]

  match "packages/check_promo_code", :to => "packages#check_promo_code", :as => "check_promo_code", :method => :post
  match "packages/choose_upgrade_method/:idea_id", :to => "packages#choose_upgrade_method", :as => "choose_upgrade_method", :via => :get
  match "packages/upgrade/:idea_id", :to => "packages#upgrade_package", :as => "package_upgrade", :via => :post

  devise_for :users, :controllers => { 
    :omniauth_callbacks => "users/omniauth_callbacks", 
    :sessions => "users/sessions", 
    :registrations => "users/registrations", 
    :passwords => "users/passwords", 
    :invitations => 'users/invitations'
  }

  match 'users/startup_idea', :to => 'users/ideas#startup_idea', :as => 'user_startup_idea', :via => :post


  get "pages/index"
  get "pages/contact", :as => "contact"
  get "pages/pricing", :as => "pricing"
  get "pages/about_us", :as => "about"
  get "pages/terms_conditions", :as => "terms"
  get "pages/privacy", :as => "privacy"
  match "newest", :to => "pages#newest", :as => "newest", :via => :get
  match "active", :to => "pages#active", :as => "active", :via => :get
  match "featured", :to => "pages#featured", :as => "featured", :via => :get





  match "/admin" => "admin/base#index", :as => "admin"

  namespace "admin" do

    resources :users
    resources :ideas do
      get "feature" => "ideas#feature", :as => "feature"
    end
    resources :surveys do 
      resources :survey_sections
    end
    resources :survey_sections do
      resources :questions
    end
    resources :questions do
      resources :answers
    end
    resources :question_groups
    resources :answers


    resources :stages, :except => [:show,:delete]

    match "fetch_answers", :to => "questions#fetch_answers", :as => "fetch_question_answers", :via => :get

    match "invitations", :to => "registration_invitations#new", :as => "new_invitations", :via => :get
    match "invitations", :to => "registration_invitations#create", :as => "create_invitations", :via => :post

    get "settings" => "settings#index", :as => "settings"
    post "settings" => "settings#update", :as => "update_settings"
  end


  match 'startup/:idea_id', :to      => 'surveyor#update', :as => 'update_tour', :via  => :put
  match 'startup/:idea_id/take', :to => 'surveyor#edit', :as   => 'edit_tour', :via    => :get

  resources :comments, :only => [:create, :new]

  resources :activity, :only => [] do
    member do
      post 'new_comment'
    end
  end

  root :to => "pages#index"


  resources :orders do
    collection do
      get 'express'
    end
  end

  match '*a', :to => 'application#missing_route'   #Catch wrong route problem
end
