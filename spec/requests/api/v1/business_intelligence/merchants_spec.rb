require 'rails_helper'
require 'rake'

describe "Merchant's business intelligence API" do
  before(:each) do
    Merchant.all.destroy_all
  end
  it "returns the top x merchants ranked by revenue" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    create_list(:invoice, 3, merchant_id: merchant_1.id)
    merchant_1.invoices.each do |invoice|
      item = create(:item, merchant_id: merchant_1.id)
      create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 3.0, quantity: 2)
      create(:transaction, invoice_id: invoice.id)
    end

    create_list(:invoice, 3, merchant_id: merchant_2.id)
    merchant_2.invoices.each do |invoice|
      item = create(:item, merchant_id: merchant_2.id)
      create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 4.0, quantity: 2)
      create(:transaction, invoice_id: invoice.id)
    end

    create_list(:invoice, 3, merchant_id: merchant_3.id)
    merchant_3.invoices.each do |invoice|
      item = create(:item, merchant_id: merchant_3.id)
      create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 5.0, quantity: 2)
      create(:transaction, invoice_id: invoice.id)
    end

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    top_1_merchant = Merchant.find(merchants["data"].first["id"])
    top_2_merchant = Merchant.find(merchants["data"].second["id"])

    expect(merchants["data"].count).to eq 2
    expect(merchants["data"]).to be_instance_of(Array)
    expect(top_1_merchant.id).to eq merchant_3.id
    expect(top_2_merchant.id).to eq merchant_2.id

  end

  # GET /api/v1/merchants/revenue?date=x returns the total revenue for date x across all merchants
  it 'returns the total revenue for date x across all merchants' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    create_list(:invoice, 3, merchant_id: merchant_1.id, created_at: '2012-03-27 14:54:09 UTC')
    merchant_1.invoices.each do |invoice|
      item = create(:item, merchant_id: merchant_1.id)
      create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 3.0, quantity: 2, created_at: '2012-03-27 14:54:09 UTC')
      create(:transaction, invoice_id: invoice.id, created_at: '2012-03-27 14:54:09 UTC')
    end

    create_list(:invoice, 3, merchant_id: merchant_2.id, created_at: '2012-03-08 20:54:10 UTC')
    merchant_2.invoices.each do |invoice|
      item = create(:item, merchant_id: merchant_2.id)
      create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 4.0, quantity: 2, created_at: '2012-03-08 20:54:10 UTC')
      create(:transaction, invoice_id: invoice.id, created_at: '2012-03-08 20:54:10 UTC')
    end

    create_list(:invoice, 3, merchant_id: merchant_3.id, created_at: '2012-03-10 10:54:10 UTC')
    merchant_3.invoices.each do |invoice|
      item = create(:item, merchant_id: merchant_3.id)
      create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 5.0, quantity: 2, created_at: '2012-03-10 10:54:10 UTC')
      create(:transaction, invoice_id: invoice.id, created_at: '2012-03-10 10:54:10 UTC')
    end


    get "/api/v1/merchants/revenue?date=#{x}"

    expect(response).to be_successful
  end
end
