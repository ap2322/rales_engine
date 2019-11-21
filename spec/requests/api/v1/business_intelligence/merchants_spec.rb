require 'rails_helper'
require 'rake'

describe "Merchant's business intelligence API" do
  # before(:each) do
  #   Merchant.all.destroy_all
  # end

  it "returns the top x merchants ranked by revenue" do
    # TODO: figure out if this test is adequate
    create_list(:merchant, 3, :with_invoices)

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    top_1_merchant = Merchant.find(merchants["data"].first["id"])
    top_2_merchant = Merchant.find(merchants["data"].second["id"])

    expect(merchants["data"].count).to eq 2
    expect(merchants["data"]).to be_instance_of(Array)

  end
end
