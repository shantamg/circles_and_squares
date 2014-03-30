CirclesAndSquares::Application.routes.draw do

  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}"
  end

  root :to => 'drawings#new'

  get 'drawings/like/:id', to: 'drawings#like' 
  get 'drawings/index/:weight', to: 'drawings#index'
  resources :drawings

end
