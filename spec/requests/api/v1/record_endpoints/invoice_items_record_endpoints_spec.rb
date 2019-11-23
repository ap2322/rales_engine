require 'rails_helper'

describe "InvoiceItem Records API" do

  before(:each) do
    InvoiceItem.all.destroy_all
  end

  it "sends a list of transactions" do
    create_list(:invoice_item, 3)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].count).to eq 3
  end

  it "shows a single invoice_items" do
    invoice_items = create(:invoice_item)

    id = invoice_items.id
    get "/api/v1/invoice_items/#{id}"

    expect(response).to be_successful
    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items["data"]["id"].to_i).to eq(id)
  end

  it "returns an invoice_item from a find query parameter" do
    invoice_1 = create(:invoice)
    item_1 = create(:item)
    invoice_item_group = create_list(:invoice_item, 3, invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 5.0)
    invoice_2 = create(:invoice)
    item_2 = create(:item)
    indv_invoice_item = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 2.0, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    attributes = ['quantity','unit_price']

    invoice_item_group.push(indv_invoice_item)

    invoice_item_group.each do |invoice_item|
      attributes.each do |attribute|
        get "/api/v1/invoice_items/find?#{attribute}=#{invoice_item.send(attribute)}"
        json_invoice_item = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_invoice_item["data"]["attributes"][attribute]).to eq(invoice_item.send(attribute).to_s)
      end
    end

    other_attributes = [ 'created_at', 'updated_at', 'invoice_id', 'item_id' ]

    small_invoice_item_group = [invoice_item_group.first, indv_invoice_item]

    small_invoice_item_group.each do |invoice_item|
      other_attributes.each do |attribute|
        unless invoice_item.send(attribute).nil?
          get "/api/v1/invoice_items/find?#{attribute}=#{invoice_item.send(attribute)}"
          json_invoice_item = JSON.parse(response.body)

          expect(response).to be_successful
          expect(json_invoice_item["data"]["id"].to_i).to eq(invoice_item.id)
        end
      end
    end
  end

  it "returns all invoice_items that match a specific query parameter" do
    invoice_1 = create(:invoice)
    item_1 = create(:item)
    invoice_item_group = create_list(:invoice_item, 3, invoice_id: invoice_1.id, item_id: item_1.id, quantity: 2, unit_price: 5.0)
    invoice_2 = create(:invoice)
    item_2 = create(:item)
    indv_invoice_item = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_2.id, quantity: 1, unit_price: 2.0, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    attributes = ['quantity','unit_price']

    invoice_item_group.push(indv_invoice_item)

    invoice_item_group.each do |invoice_item|
      attributes.each do |attribute|
        get "/api/v1/invoice_items/find_all?#{attribute}=#{invoice_item.send(attribute)}"
        json_invoice_item = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_invoice_item["data"]).to be_instance_of(Array)
        expect(json_invoice_item["data"].first["attributes"][attribute]).to eq(invoice_item.send(attribute).to_s)

        # indv vs group check
        if invoice_item.id == indv_invoice_item.id
          expect(json_invoice_item["data"].count).to eq(1)
        else
          expect(json_invoice_item["data"].count).to eq(3)
        end
      end
    end

    other_attributes = [ 'created_at', 'updated_at', 'invoice_id', 'item_id' ]

    small_invoice_item_group = [invoice_item_group.first, indv_invoice_item]

    small_invoice_item_group.each do |invoice_item|
      other_attributes.each do |attribute|
        unless invoice_item.send(attribute).nil?
          get "/api/v1/invoice_items/find_all?#{attribute}=#{invoice_item.send(attribute)}"
          json_invoice_item = JSON.parse(response.body)

          expect(response).to be_successful
          expect(json_invoice_item["data"].first["id"].to_i).to eq(invoice_item.id)

          # indv vs group check
          if invoice_item.id == indv_invoice_item.id
            expect(json_invoice_item["data"].count).to eq(1)
          else
            expect(json_invoice_item["data"].count).to eq(3)
          end
        end
      end
    end
  end

  it "returns a random record" do
    create_list(:invoice_item, 3)
    id_low = InvoiceItem.first.id
    id_high = InvoiceItem.last.id

    get "/api/v1/invoice_items/random"
    json_transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_transaction["data"]["id"].to_i).to be_between(id_low, id_high)
  end
end
