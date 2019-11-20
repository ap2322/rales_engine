require 'rails_helper'

describe "Merchants Records API" do

  after(:each) do
    Merchant.all.destroy_all
  end

  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq 3
  end

  it "shows a single merchant" do
    create(:merchant)

    id = Merchant.first.id
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"].to_i).to eq(id)
  end

  it "returns a merchant from a find query parameter" do
    create_list(:merchant, 3)
    merchant = Merchant.create!(name: "Merchant Billy-Bob", created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    get "/api/v1/merchants/find?name=#{merchant.name}"
    json_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_merchant["data"]["attributes"]["name"]).to eq("Merchant Billy-Bob")

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"
    json_merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_merchant["data"]["id"].to_i).to eq(merchant.id)

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"
    json_merchant = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_merchant["data"]["id"].to_i).to eq(merchant.id)

  end
end
