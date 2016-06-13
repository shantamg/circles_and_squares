CirclesAndSquares::Application.routes.draw do

  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}"
  end

  root :to => 'drawings#new'

  get 'drawings/like/:id', to: 'drawings#like' 
  get 'drawings/index/:weight', to: 'drawings#index'
  get 'drawings/:id', to: 'drawings#show'
  get 'drawings/:id/:for_image', to: 'drawings#show'
  get '/invert', to: 'drawings#invert'

  resources :drawings

  match '*page' => redirect('/')
end
