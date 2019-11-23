class Api::V1::InvoicesController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.all)
  end

  def show
    render json: InvoiceSerializer.new(Invoice.find(params[:id]))
  end

  def find
    render json: InvoiceSerializer.new(Invoice.find_by(request.query_parameters))
  end

  def find_all
    render json: InvoiceSerializer.new(Invoice.where(request.query_parameters))
  end

  def random
    random_id = Invoice.ids.sample
    render json: InvoiceSerializer.new(Invoice.find(random_id))
  end

end
