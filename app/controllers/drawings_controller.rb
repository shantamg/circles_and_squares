class DrawingsController < ApplicationController
  before_filter :setup_session

  def index
    @drawings = Drawing.all
  end

  def new
  end

  def create
    @drawing = Drawing.new params[:drawing]
    if @drawing.save
      render json: { }
    else
      render json: { }, status: 500
    end
  end

  def show
    @drawing = Drawing.find_by_uid(params[:id])
    @sprites = @drawing.parseSprites
    @liked   = session[:liked].include? params[:id]
  end

  def like
    @drawing = Drawing.find_by_uid(params[:id])
    unless session[:liked].include? params[:id]
      @drawing.likes = @drawing.likes + 1
      if @drawing.save
        session[:liked] << params[:id]
      end
    end
    render text: ''
  end

  def setup_session
    session[:liked] = Array.new unless session[:liked]
  end
end
