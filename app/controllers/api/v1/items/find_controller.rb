class Api::V1::Items::FindController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find_by(request.query_parameters))
  end

  def index
    render json: ItemSerializer.new(Item.where(request.query_parameters))
  end
end
