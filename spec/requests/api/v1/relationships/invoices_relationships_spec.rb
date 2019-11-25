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
end
