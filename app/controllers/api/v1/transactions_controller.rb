class Api::V1::TransactionsController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.all)
  end

  def show
    render json: TransactionSerializer.new(Transaction.find(params[:id]))
  end

  def find
    render json: TransactionSerializer.new(Transaction.find_by(request.query_parameters))
  end

  def find_all
    render json: TransactionSerializer.new(Transaction.where(request.query_parameters))
  end

  def random
    random_id = Transaction.ids.sample
    render json: TransactionSerializer.new(Transaction.find(random_id))
  end

end
