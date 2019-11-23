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

    attributes = ['invoice_id', 'credit_card_number','result']

    transaction_group.push(transaction)

    transaction_group.each do |transaction|
      attributes.each do |attribute|
        get "/api/v1/transactions/find?#{attribute}=#{transaction.send(attribute)}"
        json_transaction = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_transaction["data"]["attributes"][attribute]).to eq(transaction.send(attribute))
      end
    end

    date_attributes = [ 'credit_card_expiration_date', 'created_at', 'updated_at']

    transaction_group = [transaction_group.first, transaction]

    transaction_group.each do |transaction|
      date_attributes.each do |attribute|
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

    attributes = ['invoice_id', 'credit_card_number','result']

    transaction_group.push(indv_transaction)
    transaction_group.each do |transaction|
      attributes.each do |attribute|
        get "/api/v1/transactions/find_all?#{attribute}=#{transaction.send(attribute)}"
        json_transaction = JSON.parse(response.body)

        expect(response).to be_successful
        expect(json_transaction["data"]).to be_instance_of(Array)
        expect(json_transaction["data"].first["attributes"][attribute]).to eq(transaction.send(attribute))

        # indv vs group check
        if transaction.id == indv_transaction.id
          expect(json_transaction["data"].count).to eq(1)
        else
          expect(json_transaction["data"].count).to eq(3)
        end
      end
    end

    date_attributes = [ 'credit_card_expiration_date', 'created_at', 'updated_at']
    transaction_group = [transaction_group.first, indv_transaction]

    transaction_group.each do |transaction|
      date_attributes.each do |attribute|
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

    # get "/api/v1/items/find_all?created_at=#{item.created_at}"
    # json_items = JSON.parse(response.body)
    #
    # expect(response).to be_successful
    # expect(json_items["data"].count).to eq(1)
    # expect(json_items["data"]).to be_instance_of(Array)
    # expect(json_items["data"].first["id"]).to eq(item.id.to_s)
    #
    # get "/api/v1/items/find_all?updated_at=#{item.updated_at}"
    # json_items = JSON.parse(response.body)
    #
    # expect(response).to be_successful
    # expect(json_items["data"].count).to eq(1)
    # expect(json_items["data"]).to be_instance_of(Array)
    # expect(json_items["data"].first["id"]).to eq(item.id.to_s)
    #
    # get "/api/v1/items/find_all?merchant_id=#{item.merchant_id}"
    # json_items = JSON.parse(response.body)
    #
    # expect(response).to be_successful
    # expect(json_items["data"].count).to eq(1)
    # expect(json_items["data"]).to be_instance_of(Array)
    # expect(json_items["data"].first["id"]).to eq(item.id.to_s)
    #
    # get "/api/v1/items/find_all?merchant_id=#{merchant_1.id}"
    # json_items = JSON.parse(response.body)
    #
    # expect(response).to be_successful
    # expect(json_items["data"].count).to eq(3)
    # expect(json_items["data"]).to be_instance_of(Array)
    # item_in_collection = items.first
    # expect(json_items["data"].first["id"]).to eq(item_in_collection.id.to_s)

  end

  xit "returns a random record" do
    create_list(:item, 3)
    id_low = Item.first.id
    id_high = Item.last.id

    get "/api/v1/items/random"
    json_customer = JSON.parse(response.body)
    expect(response).to be_successful
    expect(json_customer["data"]["id"].to_i).to be_between(id_low, id_high)
  end
end
