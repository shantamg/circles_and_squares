CirclesAndSquares::Application.routes.draw do

  PagesController.action_methods.each do |action|
    get "/#{action}", to: "pages##{action}", as: "#{action}"
  end

  root :to => 'pages#index'
end
