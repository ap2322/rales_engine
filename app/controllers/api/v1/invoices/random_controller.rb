class Api::V1::Invoices::RandomController < ApplicationController
  def show
    random_id = Invoice.ids.sample
    render json: InvoiceSerializer.new(Invoice.find(random_id))
  end

end
