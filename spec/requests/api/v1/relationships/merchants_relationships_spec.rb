require 'rails_helper'

# GET /api/v1/merchants/:id/invoices returns a collection of invoices associated with that merchant from their known orders

describe "Merchants Relationships API" do

  it 'returns a collection of items associated with a merchant' do
    merchants = create_list(:merchant, 3, :with_items)
    extra_item = create(:item)
    merchants.each do |merch|
      get "/api/v1/merchants/#{merch.id}/items"
      expect(response).to be_successful
      items = JSON.parse(response.body)

      items_belong_to_merchant = items["data"].all? do |item|
        item['attributes']['merchant_id'] == merch.id
      end
      expect(items_belong_to_merchant).to be_truthy

      extra = items["data"].any? do |item|
        extra_item.id == item["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end

  it 'returns a collection of invoices associated with that merchant' do
    merchants = create_list(:merchant, 3, :with_invoices)
    extra_invoice = create(:invoice)
    merchants.each do |merch|
      get "/api/v1/merchants/#{merch.id}/invoices"
      expect(response).to be_successful
      invoices = JSON.parse(response.body)

      invoices_belong_to_merchant = invoices["data"].all? do |invoice|
        invoice['attributes']['merchant_id'] == merch.id
      end
      expect(invoices_belong_to_merchant).to be_truthy
    end
  end
end
