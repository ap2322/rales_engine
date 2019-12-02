class Api::V1::Merchants::RandomController < ApplicationController
  def show
    random_id = Merchant.ids.sample
    render json: MerchantSerializer.new(Merchant.find(random_id))
  end
end
