class DrawingsController < ApplicationController
  before_filter :setup_session

  def index
    session[:weight] ||= 'complexity'
    @drawings = Drawing.order('created_at desc')
    @field    = params[:weight] || session[:weight]
    @weight   = Drawing.weight(@drawings, @field)
    redirect_to '/' unless @weight
    session[:weight] = @field
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
    @drawing = Drawing.find(params[:id])
    @drawing.touch
    @sprites = @drawing.parseSprites
    @liked   = session[:liked].include? params[:id]
    @based_on = Drawing.find(@drawing.based_on) if @drawing.based_on
    @for_image = params[:for_image]
  rescue ActiveRecord::RecordNotFound
    redirect_to '/'
  end

  def like
    @drawing = Drawing.find(params[:id])
    unless session[:liked].include? params[:id]
      @drawing.likes = @drawing.likes + 1
      if @drawing.save
        session[:liked] << params[:id]
      end
    end
    render text: ''
  end

  def invert
    session[:invert] = session[:invert] == 'invert' ? '' : 'invert'
    render text: ''
  end

  def setup_session
    session[:liked] = Array.new unless session[:liked]
  end
end
