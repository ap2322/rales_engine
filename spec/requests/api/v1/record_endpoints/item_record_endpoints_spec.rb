require 'rails_helper'

describe "Item Records API" do

  before(:each) do
    Item.all.destroy_all
  end

  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq 3
  end

  it "shows a single item" do
    create(:item)

    id = Item.last.id
    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"].to_i).to eq(id)
  end

  it "returns an item from a find query parameter" do
    create_list(:item, 3)
    merchant = create(:merchant)
    item = Item.create!(name: "Best Thing Ever", description: "Seriously, it's the best thing ever", unit_price: 5.5, merchant_id: merchant.id, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    get "/api/v1/items/find?name=#{item.name}"
    json_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_item["data"]["attributes"]["name"]).to eq(item.name)

    get "/api/v1/items/find?description=#{item.description}"
    json_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_item["data"]["attributes"]["description"]).to eq(item.description)

    get "/api/v1/items/find?unit_price=#{item.unit_price}"
    json_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_item["data"]["attributes"]["unit_price"]).to eq("#{item.unit_price}")

    get "/api/v1/items/find?merchant_id=#{item.merchant_id}"
    json_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_item["data"]["attributes"]["merchant_id"]).to eq(item.merchant_id)

    get "/api/v1/items/find?created_at=#{item.created_at}"
    json_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_item["data"]["id"].to_i).to eq(item.id)

    get "/api/v1/items/find?updated_at=#{item.updated_at}"
    json_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_item["data"]["id"].to_i).to eq(item.id)

    get "/api/v1/items/find?id=#{item.id}"
    json_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_item["data"]["id"].to_i).to eq(item.id)

  end

  it "returns all items that match a specific query parameter" do
    merchant_1 = create(:merchant)
    items = create_list(:item, 3, name: "Thingy", description: "It's a thing", unit_price: 3.4, merchant_id: merchant_1.id)
    merchant = create(:merchant)
    item = Item.create!(name: "Best Thing Ever", description: "Seriously, it's the best thing ever", unit_price: 5.5, merchant_id: merchant.id, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    get "/api/v1/items/find_all?name=Thingy"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(3)
    expect(json_items["data"]).to be_instance_of(Array)
    expect(json_items["data"].first["attributes"]["name"]).to eq("Thingy")

    get "/api/v1/items/find_all?description=It's a thing"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(3)
    expect(json_items["data"]).to be_instance_of(Array)
    expect(json_items["data"].first["attributes"]["description"]).to eq("It's a thing")

    get "/api/v1/items/find_all?id=#{item.id}"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(1)
    expect(json_items["data"]).to be_instance_of(Array)
    expect(json_items["data"].first["id"]).to eq(item.id.to_s)

    get "/api/v1/items/find_all?created_at=#{item.created_at}"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(1)
    expect(json_items["data"]).to be_instance_of(Array)
    expect(json_items["data"].first["id"]).to eq(item.id.to_s)

    get "/api/v1/items/find_all?updated_at=#{item.updated_at}"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(1)
    expect(json_items["data"]).to be_instance_of(Array)
    expect(json_items["data"].first["id"]).to eq(item.id.to_s)

    get "/api/v1/items/find_all?merchant_id=#{item.merchant_id}"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(1)
    expect(json_items["data"]).to be_instance_of(Array)
    expect(json_items["data"].first["id"]).to eq(item.id.to_s)

    get "/api/v1/items/find_all?merchant_id=#{merchant_1.id}"
    json_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_items["data"].count).to eq(3)
    expect(json_items["data"]).to be_instance_of(Array)
    item_in_collection = items.first
    expect(json_items["data"].first["id"]).to eq(item_in_collection.id.to_s)

  end

  it "returns a random record" do
    create_list(:item, 3)
    id_low = Item.first.id
    id_high = Item.last.id

    get "/api/v1/items/random"
    json_item = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_item["data"]["id"].to_i).to be_between(id_low, id_high)
  end
end
