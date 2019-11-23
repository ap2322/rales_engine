require 'rails_helper'

describe "Transaction Records API" do

  before(:each) do
    Transaction.all.destroy_all
  end

  it "sends a list of transactions" do
    create_list(:transaction, 3)

    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"].count).to eq 3
  end

  it "shows a single transaction" do
    transaction = create(:transaction)

    id = transaction.id
    get "/api/v1/transactions/#{id}"

    expect(response).to be_successful
    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"].to_i).to eq(id)
  end

  it "returns an item from a find query parameter" do
    transaction_group = create_list(:transaction, 3)
    invoice = create(:invoice)
    transaction = Transaction.create!(credit_card_number: 4844518708741275, credit_card_expiration_date: nil, result: 'success', invoice_id: invoice.id, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    attributes = ['credit_card_number','result']

    transaction_group.push(transaction)

    transaction_group.each do |transaction|
      attributes.each do |attribute|
        get "/api/v1/transactions/find?#{attribute}=#{transaction.send(attribute)}"
        json_transaction = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_transaction["data"]["attributes"][attribute]).to eq(transaction.send(attribute).to_s)
      end
    end

    other_attributes = [ 'created_at', 'updated_at', 'invoice_id' ]

    transaction_group = [transaction_group.first, transaction]

    transaction_group.each do |transaction|
      other_attributes.each do |attribute|
        unless transaction.send(attribute).nil?
          get "/api/v1/transactions/find?#{attribute}=#{transaction.send(attribute)}"
          json_transaction = JSON.parse(response.body)

          expect(response).to be_successful
          expect(json_transaction["data"]["id"].to_i).to eq(transaction.id)
        end
      end
    end
  end

  it "returns all transactions that match a specific query parameter" do
    invoice_1 = create(:invoice)
    transaction_group = create_list(:transaction, 3, :credit_card_number => 4000000000000000, invoice_id: invoice_1.id, result: 0)
    invoice = create(:invoice)
    indv_transaction = Transaction.create!(credit_card_number: 4844518708741275, credit_card_expiration_date: nil, result: 'success', invoice_id: invoice.id, created_at: "2012-03-27 14:53:59", updated_at: "2015-03-27 14:53:59")

    attributes = ['credit_card_number','result']

    transaction_group.push(indv_transaction)
    transaction_group.each do |transaction|
      attributes.each do |attribute|
        get "/api/v1/transactions/find_all?#{attribute}=#{transaction.send(attribute)}"
        json_transaction = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_transaction["data"]).to be_instance_of(Array)
        expect(json_transaction["data"].first["attributes"][attribute]).to eq(transaction.send(attribute).to_s)

        # indv vs group check
        if transaction.id == indv_transaction.id
          expect(json_transaction["data"].count).to eq(1)
        else
          expect(json_transaction["data"].count).to eq(3)
        end
      end
    end

    other_attributes = [ 'created_at', 'updated_at', 'invoice_id' ]
    transaction_group = [transaction_group.first, indv_transaction]

    transaction_group.each do |transaction|
      other_attributes.each do |attribute|
        unless transaction.send(attribute).nil?
          get "/api/v1/transactions/find_all?#{attribute}=#{transaction.send(attribute)}"
          json_transaction = JSON.parse(response.body)

          expect(response).to be_successful
          expect(json_transaction["data"].first["id"].to_i).to eq(transaction.id)

          # indv vs group check
          if transaction.id == indv_transaction.id
            expect(json_transaction["data"].count).to eq(1)
          else
            expect(json_transaction["data"].count).to eq(3)
          end
        end
      end
    end
  end

  it "returns a random record" do
    create_list(:transaction, 3)
    id_low = Transaction.first.id
    id_high = Transaction.last.id

    get "/api/v1/transactions/random"
    json_transaction = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_transaction["data"]["id"].to_i).to be_between(id_low, id_high)
  end
end
