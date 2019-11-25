require 'rails_helper'

describe "Invoices Relationships API" do

  it 'returns a collection of transactions associated with an invoice' do
    invoices = create_list(:invoice, 3, :with_transactions, transaction_count: 2)
    extra_transaction = create(:transaction)
    invoices.each do |inv|
      get "/api/v1/invoices/#{inv.id}/transactions"
      expect(response).to be_successful
      transactions = JSON.parse(response.body)

      transactions_belong_to_invoices = transactions["data"].all? do |trans|
        trans['attributes']['invoice_id'] == inv.id
      end
      expect(transactions_belong_to_invoices).to be_truthy

      extra = transactions["data"].any? do |trans|
        extra_transaction.id == trans["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end

  it 'returns a collection of invoice_items associated with that invoice' do
    invoices = create_list(:invoice, 3, :with_invoice_items, invoice_item_count: 2)
    extra_invoice_item = create(:invoice_item)
    invoices.each do |inv|
      get "/api/v1/invoices/#{inv.id}/invoice_items"
      expect(response).to be_successful
      invoice_items = JSON.parse(response.body)

      invoice_items_belong_to_invoices = invoice_items["data"].all? do |inv_item|
        inv_item['attributes']['invoice_id'] == inv.id
      end
      expect(invoice_items_belong_to_invoices).to be_truthy

      extra = invoice_items["data"].any? do |inv_item|
        extra_invoice_item.id == inv_item["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end

  it 'returns a collection of items associated with that invoice' do
    invoices = create_list(:invoice, 3, :with_invoice_items, invoice_item_count: 2)
    extra_item = create(:item)
    invoices.each do |inv|
      get "/api/v1/invoices/#{inv.id}/items"
      expect(response).to be_successful
      items = JSON.parse(response.body)

      items_belong_to_invoices = items["data"].all? do |item|
        inv.items.ids.include?(item["attributes"]["id"])
      end

      expect(items_belong_to_invoices).to be_truthy

      extra = items["data"].any? do |item|
        extra_item.id == item["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end

  it 'returns a collection of customers associated with that invoice' do
    customer = create(:customer)
    invoices = create_list(:invoice, 3, customer_id: customer.id)
    extra_customer = create(:customer)
    invoices.each do |inv|
      get "/api/v1/invoices/#{inv.id}/customers"
      expect(response).to be_successful
      customer = JSON.parse(response.body)

      expect(customer["data"]["attributes"]["id"]).to eq(inv.customer.id)

      extra = customer["data"]["attributes"]["id"] == extra_customer.id
      expect(extra).to be_falsy
    end
  end
# GET /api/v1/invoices/:id/merchant returns the associated merchant
  it 'returns a collection of merchants associated with that invoice' do
    merch = create(:merchant)
    invoices = create_list(:invoice, 3, merchant_id: merch.id)
    extra_merchant = create(:merchant)
    invoices.each do |inv|
      get "/api/v1/invoices/#{inv.id}/merchants"
      expect(response).to be_successful
      merchant = JSON.parse(response.body)

      expect(merchant["data"]["attributes"]["id"]).to eq(inv.merchant.id)

      extra = merchant["data"]["attributes"]["id"] == extra_merchant.id
      expect(extra).to be_falsy
    end
  end
end
