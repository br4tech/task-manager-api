require 'api_version_constraint'

Rails.application.routes.draw do
   devise_for :users, only: [:sessions], controllers: {sessions: 'api/v1/sessions'}

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults:{ format: :json}, constrants: { subdomain: 'api'}, path: '/' do
        namespace :v1, path: '/', constrants: ApiVersionConstraint.new(version: 1, default: true) do
             resources :users, only: [:show, :create, :update, :destroy]
             resources :sessions, only: [:create, :destroy]
             resources :tasks, only: [:index, :show]
        end

        # namespace :v2, path: "/", constrants: ApiVersionConstraint.new(version: 2, default: true) do
        #   resources :tasks
        # end
  end
end
