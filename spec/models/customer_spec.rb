require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it {should validate_presence_of :first_name}
    it {should validate_presence_of :last_name}
  end

  describe 'relationships' do
    it {should have_many :invoices}
  end

  describe 'methods' do
    it 'returns the merchant for a customer where they had the most successful transactions' do
      customer = create(:customer)
      merchants = create_list(:merchant, 3)

      merchants.each do |merchant|
        invoice = create(:invoice, merchant_id: merchant.id, customer_id: customer.id)
        create(:transaction, invoice_id: invoice.id)
      end

      # more_invoices_and_transactions for the last merchant
      second_merchant = merchants[1]
      invoices = create_list(:invoice, 2, merchant_id: second_merchant.id, customer_id: customer.id)
      invoices.each { |invoice| create(:transaction, invoice_id: invoice.id)}
      expect(customer.favorite_merchant).to eq(second_merchant)
    end
  end
end
