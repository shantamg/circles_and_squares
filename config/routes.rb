CirclesAndSquares::Application.routes.draw do

  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}"
  end

  root :to => 'drawings#new'

  resources :drawings
  get 'drawings/like/:id', to: 'drawings#like' 

end
