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
end
