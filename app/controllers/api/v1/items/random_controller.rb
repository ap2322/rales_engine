class Api::V1::Items::RandomController < ApplicationController
  def show
    random_id = Item.ids.sample
    render json: ItemSerializer.new(Item.find(random_id))
  end
end
