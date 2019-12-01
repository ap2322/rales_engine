class Api::V1::Items::BestDayController < ApplicationController
  def show
    item = Item.find(params["item_id"])
    render json: best_day_hash(item.best_day, params["item_id"])
  end


  private
  def best_day_hash(best_day, item_id)
    {"data": {"id": item_id, "attributes": {"best_day": "#{best_day}"}}}
  end
end
