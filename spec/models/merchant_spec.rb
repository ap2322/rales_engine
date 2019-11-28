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

    it 'deletes all invoices when a merchant is destroyed' do
      merchant = create(:merchant, :with_invoices, :invoice_count => 1)
      invoice = merchant.invoices.last

      Merchant.destroy(merchant.id)
      expect{Invoice.find(invoice.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'methods' do
    it 'returns the x number of merchants with the highest revenue' do
      Merchant.all.destroy_all
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      create_list(:invoice, 3, merchant_id: merchant_1.id)
      merchant_1.invoices.each do |invoice|
        item = create(:item, merchant_id: merchant_1.id)
        create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 3.0, quantity: 2)
        create(:transaction, invoice_id: invoice.id)
      end

      create_list(:invoice, 3, merchant_id: merchant_2.id)
      merchant_2.invoices.each do |invoice|
        item = create(:item, merchant_id: merchant_2.id)
        create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 4.0, quantity: 2)
        create(:transaction, invoice_id: invoice.id)
      end

      create_list(:invoice, 3, merchant_id: merchant_3.id)
      merchant_3.invoices.each do |invoice|
        item = create(:item, merchant_id: merchant_3.id)
        create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 5.0, quantity: 2)
        create(:transaction, invoice_id: invoice.id)
      end

      top_two = Merchant.most_revenue(2)
      expect(top_two).to eq([merchant_3, merchant_2])
    end

    it 'returns the total revenue for date x across all merchants' do
      Merchant.all.destroy_all
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      create_list(:invoice, 3, merchant_id: merchant_1.id, created_at: '2012-03-27 14:54:09 UTC')
      merchant_1.invoices.each do |invoice|
        item = create(:item, merchant_id: merchant_1.id)
        create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 3.0, quantity: 2, created_at: '2012-03-27 14:54:09 UTC')
        create(:transaction, invoice_id: invoice.id, created_at: '2012-03-27 14:54:09 UTC')
      end

      create_list(:invoice, 3, merchant_id: merchant_2.id, created_at: '2012-03-08 20:54:10 UTC')
      merchant_2.invoices.each do |invoice|
        item = create(:item, merchant_id: merchant_2.id)
        create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 4.0, quantity: 2, created_at: '2012-03-08 20:54:10 UTC')
        create(:transaction, invoice_id: invoice.id, created_at: '2012-03-08 20:54:10 UTC')
      end

      create_list(:invoice, 3, merchant_id: merchant_3.id, created_at: '2012-03-10 10:54:10 UTC')
      merchant_3.invoices.each do |invoice|
        item = create(:item, merchant_id: merchant_3.id)
        create(:invoice_item, invoice_id: invoice.id, item_id: item.id, unit_price: 5.0, quantity: 2, created_at: '2012-03-10 10:54:10 UTC')
        create(:transaction, invoice_id: invoice.id, created_at: '2012-03-10 10:54:10 UTC')
      end

      date_1 = '2012-03-27'
      date_2 = '2012-03-10'

      total_date_1 = 18
      total_date_2 = 30

      expect(Merchant.revenue(date_1)).to eq(total_date_1)
      expect(Merchant.revenue(date_2)).to eq(total_date_2)
    end
  end
end
