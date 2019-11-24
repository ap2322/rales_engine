require 'rails_helper'

# GET /api/v1/merchants/:id/items returns a collection of items associated with that merchant
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
end
