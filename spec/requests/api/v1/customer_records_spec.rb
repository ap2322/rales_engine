require 'rails_helper'

describe "Customer Records API" do

  before(:each) do
    Customer.all.destroy_all
  end

  it "sends a list of customers" do
    create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq 3
  end

  it "shows a single customer" do
    create(:customer)

    id = Customer.last.id
    get "/api/v1/customers/#{id}"

    expect(response).to be_successful
    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"].to_i).to eq(id)
  end

  it "returns a customer from a find query parameter" do
    create_list(:customer, 3)
    customer = Customer.create!(first_name: "Customer", last_name: "Joe", created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    get "/api/v1/customers/find?first_name=#{customer.first_name}"
    json_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customer["data"]["attributes"]["first_name"]).to eq(customer.first_name)

    get "/api/v1/customers/find?last_name=#{customer.last_name}"
    json_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customer["data"]["attributes"]["last_name"]).to eq(customer.last_name)

    get "/api/v1/customers/find?created_at=#{customer.created_at}"
    json_customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_customer["data"]["id"].to_i).to eq(customer.id)

    get "/api/v1/customers/find?updated_at=#{customer.updated_at}"
    json_customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_customer["data"]["id"].to_i).to eq(customer.id)

    get "/api/v1/customers/find?id=#{customer.id}"
    json_customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_customer["data"]["id"].to_i).to eq(customer.id)

  end

  it "returns all customers that match a specific query parameter" do
    create_list(:customer, 3, first_name: "Jim", last_name: "James")
    customer = Customer.create!(first_name: "Customer", last_name: "Joe", created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    get "/api/v1/customers/find_all?first_name=Jim"
    json_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customers["data"].count).to eq(3)
    expect(json_customers["data"]).to be_instance_of(Array)
    expect(json_customers["data"].first["attributes"]["first_name"]).to eq("Jim")

    get "/api/v1/customers/find_all?last_name=James"
    json_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customers["data"].count).to eq(3)
    expect(json_customers["data"]).to be_instance_of(Array)
    expect(json_customers["data"].first["attributes"]["last_name"]).to eq("James")

    get "/api/v1/customers/find_all?id=#{customer.id}"
    json_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customers["data"].count).to eq(1)
    expect(json_customers["data"]).to be_instance_of(Array)
    expect(json_customers["data"].first["id"]).to eq(customer.id.to_s)

    get "/api/v1/customers/find_all?created_at=#{customer.created_at}"
    json_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customers["data"].count).to eq(1)
    expect(json_customers["data"]).to be_instance_of(Array)
    expect(json_customers["data"].first["id"]).to eq(customer.id.to_s)

    get "/api/v1/customers/find_all?updated_at=#{customer.updated_at}"
    json_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json_customers["data"].count).to eq(1)
    expect(json_customers["data"]).to be_instance_of(Array)
    expect(json_customers["data"].first["id"]).to eq(customer.id.to_s)

  end

  it "returns a random record" do
    create_list(:customer, 3)
    id_low = Customer.first.id
    id_high = Customer.last.id

    get "/api/v1/customers/random"
    json_customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_customer["data"]["id"].to_i).to be_between(id_low, id_high)
  end
end
