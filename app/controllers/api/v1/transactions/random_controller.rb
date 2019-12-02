class Api::V1::Transactions::RandomController < ApplicationController
  def show
    random_id = Transaction.ids.sample
    render json: TransactionSerializer.new(Transaction.find(random_id))
  end
end
