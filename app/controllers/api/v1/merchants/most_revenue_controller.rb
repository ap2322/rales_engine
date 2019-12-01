class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    render json: MerchantSerializer.new(
      Merchant.most_revenue(request.query_parameters["quantity"].to_i))
  end
end
