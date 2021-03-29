Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  post 'user_token' => 'user_token#create'
  post 'authenticate', to: 'authentication#authenticate'
  get '/comments', to: 'articles#get_comments'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :articles , :users , :comments
      get "/articles/comments/:id" => "articles#show_comments"
    end
  end
end