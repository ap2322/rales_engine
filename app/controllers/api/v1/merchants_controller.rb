class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    render json: MerchantSerializer.new(Merchant.find_by(request.query_parameters))
  end

  def find_all
    render json: MerchantSerializer.new(Merchant.where(request.query_parameters))
  end

  def random
    random_id = Merchant.ids.sample
    render json: MerchantSerializer.new(Merchant.find(random_id))
  end

end
