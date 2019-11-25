require 'rails_helper'

describe "Transactions Relationships API" do

  it 'returns an invoice associated with that transaction' do
    inv_1 = create(:invoice)
    transactions = create_list(:transaction, 3, invoice_id: inv_1.id)
    extra_invoice = create(:invoice)
    transactions.each do |transaction|
      get "/api/v1/transactions/#{transaction.id}/invoice"
      expect(response).to be_successful
      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["id"]).to eq(transaction.invoice.id)

      extra = invoice["data"]["attributes"]["id"] == extra_invoice.id
      expect(extra).to be_falsy
    end
  end

end
