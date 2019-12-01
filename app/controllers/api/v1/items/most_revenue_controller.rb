class Api::V1::Items::MostRevenueController < ApplicationController
  def index
    render json: ItemSerializer.new(
      Item.most_revenue(request.query_parameters["quantity"].to_i))
  end
end
