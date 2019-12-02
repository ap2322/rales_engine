class Api::V1::Invoices::FindController < ApplicationController

  def show
    render json: InvoiceSerializer.new(Invoice.find_by(request.query_parameters))
  end

  def index
    render json: InvoiceSerializer.new(Invoice.where(request.query_parameters))
  end
  
end
