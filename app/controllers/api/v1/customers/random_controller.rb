class Api::V1::Customers::RandomController < ApplicationController
  def show
    random_id = Customer.ids.sample
    render json: CustomerSerializer.new(Customer.find(random_id))
  end

end
