class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def find
    render json: ItemSerializer.new(Item.find_by(request.query_parameters))
  end

  def find_all
    render json: ItemSerializer.new(Item.where(request.query_parameters))
  end

  def random
    random_id = Item.ids.sample
    render json: ItemSerializer.new(Item.find(random_id))
  end

end
