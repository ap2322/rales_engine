require 'rails_helper'

# GET /api/v1/items/most_revenue?quantity=x returns the top x items ranked by total revenue generated
describe 'Items business intelligence endpoints' do
  before(:each) do
    Merchant.all.destroy_all
    Item.all.destroy_all
  end
  it 'returns the top x items ranked by total revenue generated' do
    # Make 3 items connected to invoice items, invoices, and transactions
    item_1 = create(:item, unit_price: 2.1)
    item_2 = create(:item, unit_price: 3.5)
    item_3 = create(:item, unit_price: 2.8)

    invoice_1 = create(:invoice, merchant_id: item_1.merchant.id)
    invoice_2 = create(:invoice, merchant_id: item_2.merchant.id)
    invoice_3 = create(:invoice, merchant_id: item_3.merchant.id)

    create_list(:invoice_item, 3, invoice_id: invoice_1.id, item_id: item_1.id, unit_price: item_1.unit_price, quantity: 2)
    create_list(:invoice_item, 3, invoice_id: invoice_2.id, item_id: item_2.id, unit_price: item_2.unit_price, quantity: 4)
    create_list(:invoice_item, 3, invoice_id: invoice_3.id, item_id: item_3.id, unit_price: item_3.unit_price, quantity: 3)

    [invoice_1, invoice_2, invoice_3].each do |invoice|
      create(:transaction, invoice_id: invoice.id)
    end

    get "/api/v1/items/most_revenue?quantity=2"

    expect(response).to be_successful
    items = JSON.parse(response.body)

    top_1_item = Item.find(items["data"].first["id"])
    top_2_item = Item.find(items["data"].second["id"])

    expect(items["data"].count).to eq 2
    expect(items["data"]).to be_instance_of(Array)
    expect(top_1_item.id).to eq item_2.id
    expect(top_2_item.id).to eq item_3.id

  end

  # GET /api/v1/items/:id/best_day returns the date with the most sales for the given item using the invoice date. If there are multiple days with equal number of sales, return the most recent day.
  it 'returns the date with the most sales for the given item using the invoice date' do
    item_1 = create(:item, unit_price: 2.1)
    item_2 = create(:item, unit_price: 3.5)

    invoice_1 = create(:invoice, merchant_id: item_1.merchant.id, created_at: '2012-03-27 14:54:09 UTC')
    invoice_2 = create(:invoice, merchant_id: item_2.merchant.id, created_at: '2012-03-08 20:54:10 UTC')
    invoice_3 = create(:invoice, merchant_id: item_1.merchant.id, created_at: '2012-03-27 14:54:09 UTC')

    create_list(:invoice_item, 3, invoice_id: invoice_1.id, item_id: item_1.id, unit_price: item_1.unit_price, quantity: 2, created_at: '2012-03-27 14:54:09 UTC')
    create_list(:invoice_item, 3, invoice_id: invoice_2.id, item_id: item_2.id, unit_price: item_2.unit_price, quantity: 4, created_at: '2012-03-08 20:54:10 UTC')
    create_list(:invoice_item, 3, invoice_id: invoice_3.id, item_id: item_1.id, unit_price: item_1.unit_price, quantity: 3, created_at: '2012-03-27 14:54:09 UTC')

    [invoice_1, invoice_2, invoice_3].each do |invoice|
      create(:transaction, invoice_id: invoice.id)
    end

    get "/api/v1/items/#{item_1.id}/best_day"

    expect(response).to be_successful

    best_day_data = JSON.parse(response.body)

    expect(best_day_data["data"]["attributes"]["best_day"]).to eq('2012-03-27')

  end

end
