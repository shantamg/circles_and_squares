class DrawingsController < ApplicationController
  before_filter :setup_session

  def index
    @drawings = Drawing.all
    @field    = params[:weight] || :complexity
    @weight   = Drawing.weight(@drawings, @field)
  end

  def new
  end

  def create
    @drawing = Drawing.new params[:drawing]
    if @drawing.save
      render json: {
        name: @drawing.camel_name,
        url: (url_for @drawing)
      }
    else
      render json: { }, status: 500
    end
  end

  def show
    @drawing = Drawing.find_by_uid(params[:id])
    @sprites = @drawing.parseSprites
    @liked   = session[:liked].include? params[:id]
    @based_on = Drawing.find_by_uid(@drawing.based_on) if @drawing.based_on
  rescue ActiveRecord::RecordNotFound
    redirect_to '/'
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
