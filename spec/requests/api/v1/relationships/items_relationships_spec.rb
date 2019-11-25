require 'rails_helper'

describe "Items Relationships API" do

  it 'returns a collection of invoice_items associated with an item' do
    items = create_list(:item, 3, :with_invoice_items)
    extra_invoice_item = create(:invoice_item)

    items.each do |item|
      get "/api/v1/items/#{item.id}/invoice_items"
      expect(response).to be_successful
      invoice_items = JSON.parse(response.body)
      
      invoice_items_belong_to_items = invoice_items["data"].all? do |inv_item|
        inv_item['attributes']['item_id'] == item.id
      end
      expect(invoice_items_belong_to_items).to be_truthy

      extra = invoice_items["data"].any? do |inv_item|
        extra_invoice_item.id == inv_item["attributes"]["id"]
      end
      expect(extra).to be_falsy
    end
  end

  xit 'returns a merchant associated with that invoice' do
    merch = create(:merchant)
    invoices = create_list(:invoice, 3, merchant_id: merch.id)
    extra_merchant = create(:merchant)
    invoices.each do |inv|
      get "/api/v1/invoices/#{inv.id}/merchant"
      expect(response).to be_successful
      merchant = JSON.parse(response.body)

      expect(merchant["data"]["attributes"]["id"]).to eq(inv.merchant.id)

      extra = merchant["data"]["attributes"]["id"] == extra_merchant.id
      expect(extra).to be_falsy
    end
  end
end
