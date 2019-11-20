class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    if params[:id] = "find"
      render json: MerchantSerializer.new(Merchant.find_by(request.query_parameters))
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end
end
