class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_invert

  def set_invert
    session[:invert] = '' unless session[:invert]
  end
end
