require 'rails_helper'

describe "Invoice Items Relationships API" do

  it 'returns an invoice associated with that invoice_item' do
    inv_1 = create(:invoice)
    invoice_items = create_list(:invoice_item, 3, invoice_id: inv_1.id)
    extra_invoice = create(:invoice)
    invoice_items.each do |inv_item|
      get "/api/v1/invoice_items/#{inv_item.id}/invoice"
      expect(response).to be_successful
      invoice = JSON.parse(response.body)

      expect(invoice["data"]["attributes"]["id"]).to eq(inv_item.invoice.id)

      extra = invoice["data"]["attributes"]["id"] == extra_invoice.id
      expect(extra).to be_falsy
    end
  end

  it 'returns an item associated with that invoice_item' do
    item_1 = create(:item)
    invoice_items = create_list(:invoice_item, 3, item_id: item_1.id)
    extra_item = create(:item)
    invoice_items.each do |inv_item|
      get "/api/v1/invoice_items/#{inv_item.id}/item"
      expect(response).to be_successful
      item = JSON.parse(response.body)

      expect(item["data"]["attributes"]["id"]).to eq(inv_item.item.id)

      extra = item["data"]["attributes"]["id"] == extra_item.id
      expect(extra).to be_falsy
    end
  end
end
