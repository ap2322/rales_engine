require 'rails_helper'

describe "Merchants Records API" do
  before(:each) do
    create_list(:merchant, 3)
  end

  after(:all) do
    Merchant.all.delete_all
  end

  it "sends a list of merchants" do
    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq 3
  end

  it "shows a single merchant" do
    id = Merchant.first.id
    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful
    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end
end
