require 'rails_helper'
require 'rake'

describe "Merchant's business intelligence API" do
  before(:each) do
    Merchant.all.destroy_all
  end

  it "returns the top x merchants ranked by revenue" do
    merchants = create_list(:merchant, 3, :with_invoices)

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq 2
    expect(json_merchants["data"]).to be_instance_of(Array)

    #How to test for revenue column?
  end
end
