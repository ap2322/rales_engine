class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: revenue_hash(Merchant.revenue(request.query_parameters["date"]))
  end

  private
  def revenue_hash(total_revenue)
    {"data": {"attributes": {"total_revenue": "#{total_revenue}"}}}
  end
end
