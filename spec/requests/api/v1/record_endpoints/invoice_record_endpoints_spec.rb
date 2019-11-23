require 'rails_helper'

describe "Invoice Records API" do

  before(:each) do
    Invoice.all.destroy_all
  end

  it "sends a list of invoices" do
    create_list(:invoice, 3)

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq 3
  end

  it "shows a single invoice" do
    create(:invoice)

    id = Invoice.last.id
    get "/api/v1/invoices/#{id}"

    expect(response).to be_successful
    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"].to_i).to eq(id)
  end

  it "returns an invoice from a find query parameter" do
    create_list(:invoice, 3)
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = Invoice.create!(status: 'shipped', customer_id: customer.id, merchant_id: merchant.id, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    # attributes = ["status", "customer_id", "merchant_id"]
    #
    # attributes.each do |attribute|
    #   get "/api/v1/invoices/find?#{attribute}=#{invoice.send(attribute)}"
    #   json_invoice = JSON.parse(response.body)
    #
    #   expect(response).to be_successful
    #   expect(json_invoice["data"]["attributes"][attribute]).to eq(invoice.send(attribute))
    # end

    hidden_attributes = ["created_at", "updated_at"]

    hidden_attributes.each do |attribute|
      get "/api/v1/invoices/find?#{attribute}=#{invoice.send(attribute)}"

      json_invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(json_invoice["data"]["id"].to_i).to eq(invoice.id)
    end

  end

  it "returns all invoices that match a specific query parameter" do
    merchant_1 = create(:merchant)
    customer_1 = create(:customer)
    invoices = create_list(:invoice, 3, merchant_id: merchant_1.id, customer_id: customer_1.id, status: 'pending')
    invoice_in_group = invoices.first
    merchant = create(:merchant)
    customer = create(:customer)
    invoice = Invoice.create!(status: 'shipped', customer_id: customer.id, merchant_id: merchant.id, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")


    attributes = ['status', 'merchant_id', 'customer_id']

    attributes.each do |attribute|
      get "/api/v1/invoices/find_all?#{attribute}=#{invoice_in_group.send(attribute)}"
      json_invoices = JSON.parse(response.body)
      expect(response).to be_successful
      expect(json_invoices["data"].count).to eq(3)
      expect(json_invoices["data"]).to be_instance_of(Array)
      expect(json_invoices["data"].first["attributes"][attribute]).to eq(invoice_in_group.send(attribute))
    end

    attributes.each do |attribute|
      get "/api/v1/invoices/find_all?#{attribute}=#{invoice.send(attribute)}"
      json_invoices = JSON.parse(response.body)
      expect(response).to be_successful
      expect(json_invoices["data"].count).to eq(1)
      expect(json_invoices["data"]).to be_instance_of(Array)
      expect(json_invoices["data"].first["attributes"][attribute]).to eq(invoice.send(attribute))
    end

    hidden_attributes = [ "created_at", "updated_at"]

    hidden_attributes.each do |attribute|
      get "/api/v1/invoices/find_all?#{attribute}=#{invoice_in_group.send(attribute)}"
      json_invoices = JSON.parse(response.body)

      expect(response).to be_successful

      expect(json_invoices["data"].count).to eq(3)
      expect(json_invoices["data"]).to be_instance_of(Array)
      expect(json_invoices["data"].first["id"]).to eq(invoice_in_group.id.to_s)
    end

    hidden_attributes.each do |attribute|
      get "/api/v1/invoices/find_all?#{attribute}=#{invoice.send(attribute)}"
      json_invoices = JSON.parse(response.body)

      expect(response).to be_successful

      expect(json_invoices["data"].count).to eq(1)
      expect(json_invoices["data"]).to be_instance_of(Array)
      expect(json_invoices["data"].first["id"]).to eq(invoice.id.to_s)
    end
  end

  it "returns a random record" do
    create_list(:invoice, 3)
    id_low = Invoice.first.id
    id_high = Invoice.last.id

    get "/api/v1/invoices/random"
    json_customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_customer["data"]["id"].to_i).to be_between(id_low, id_high)
  end
end
