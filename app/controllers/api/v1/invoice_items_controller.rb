class Api::V1::InvoiceItemsController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.all)
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find(params[:id]))
  end

  def find
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(request.query_parameters))
  end

  def find_all
    render json: InvoiceItemSerializer.new(InvoiceItem.where(request.query_parameters))
  end

  def random
    random_id = InvoiceItem.ids.sample
    render json: InvoiceItemSerializer.new(InvoiceItem.find(random_id))
  end

end
