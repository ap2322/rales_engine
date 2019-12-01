require 'rails_helper'

describe 'Customer business intelligence endpoints' do
  # GET /api/v1/customers/:id/favorite_merchant returns a merchant where the customer has conducted the most successful transactions
  it 'returns a merchant where the customer has conducted the most successful transactions' do
    customer = create(:customer)
    merchants = create_list(:merchant, 3)

    merchants.each do |merchant|
      invoice = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
      create(:transaction, invoice_id: invoice.id)
    end

    # more_invoices_and_transactions for the last merchant
    invoices = create_list(:invoice, 2, merchant_id: merchants.second.id, customer_id: customer.id)
    invoices.each { |invoice| create(:transaction, invoice_id: invoice.id)}

    get "/api/v1/customers/#{customer.id}/favorite_merchant"

    expect(response).to be_successful
    merchant = JSON.parse(response.body)

    expect(merchant["data"]["id"].to_i).to eq(merchants.second.id)

  end
end
