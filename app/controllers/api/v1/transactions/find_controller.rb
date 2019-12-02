class Api::V1::Transactions::FindController < ApplicationController
  def show
    render json: TransactionSerializer.new(Transaction.find_by(request.query_parameters))
  end

  def index
    render json: TransactionSerializer.new(Transaction.where(request.query_parameters))
  end
end
