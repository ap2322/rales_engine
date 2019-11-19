require 'rails_helper'

describe "Merchants Records API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchant'

    expect(response).to be_successful
  end
end
