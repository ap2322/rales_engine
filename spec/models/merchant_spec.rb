require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :invoices}
    it {should have_many(:invoice_items).through(:invoices)}
    it {should have_many(:transactions).through(:invoices)}
  end

  describe 'dependencies' do
    it 'deletes all items when a merchant is destroyed' do
      item = create(:item)
      merchant = Merchant.find(item.merchant_id)

      Merchant.destroy(merchant.id)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    xit 'deletes all invoices when a merchant is destroyed' do
      merchant = create(:merchant, :with_invoices, :invoice_count => 1)
      invoice = merchant.invoices.last

      Merchant.destroy(merchant.id)
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'methods' do
    it 'returns the x number of merchants with the highest revenue' do
      merchants = create_list(:merchant, 5, :with_invoices)
      merchant_1 = merchants.first
      merchant_2 = merchants.second
      merchant_3 = merchants.third
      merchant_4 = merchants.fourth
      merchant_5 = merchants.fifth

      top_three = Merchant.most_revenue(3)
      expect(top_three).to eq([merchant_5, merchant_4, merchant_3])
    end
  end
end
