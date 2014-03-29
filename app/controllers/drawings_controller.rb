class DrawingsController < ApplicationController
  def index
    @drawings = Drawing.all
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
  end
end
