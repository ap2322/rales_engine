require 'rails_helper'

describe "Customers Relationships API" do

  it 'returns a collection of invoices associated with that customer' do
    customers = create_list(:customer, 3, :with_invoices)
    extra_invoice = create(:invoice)

    customers.each do |customer|
      get "/api/v1/customers/#{customer.id}/invoices"
      expect(response).to be_successful
      invoices = JSON.parse(response.body)

      invoices_belong_to_customer= invoices["data"].all? do |invoice|
        invoice['attributes']['customer_id'] == customer.id
      end
      expect(invoices_belong_to_customer).to be_truthy

      extra = invoices["data"].any? do |invoice|
        extra_invoice.id == invoice["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end

  it 'returns a collection of transactions associated with a customer' do
    customers = create_list(:customer, 3, :with_invoices)
    extra_transaction = create(:transaction)

    customers.each do |customer|
      get "/api/v1/customers/#{customer.id}/transactions"
      expect(response).to be_successful
      transactions = JSON.parse(response.body)

      transactions_belong_to_customer = transactions["data"].all? do |transaction|
        customer.transactions.ids.include?(transaction['attributes']['id'])
      end
      expect(transactions_belong_to_customer).to be_truthy

      extra = transactions["data"].any? do |transaction|
        extra_transaction.id == transaction["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end
end
