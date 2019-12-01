require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
  end

  describe 'methods' do
    it 'returns the top x items ranked by revenue' do
      item_1 = create(:item, unit_price: 2.1)
      item_2 = create(:item, unit_price: 3.5)
      item_3 = create(:item, unit_price: 2.8)

      invoice_1 = create(:invoice, merchant_id: item_1.merchant.id)
      invoice_2 = create(:invoice, merchant_id: item_2.merchant.id)
      invoice_3 = create(:invoice, merchant_id: item_3.merchant.id)

      create_list(:invoice_item, 3, invoice_id: invoice_1.id, item_id: item_1.id, unit_price: item_1.unit_price, quantity: 2)
      create_list(:invoice_item, 3, invoice_id: invoice_2.id, item_id: item_2.id, unit_price: item_2.unit_price, quantity: 4)
      create_list(:invoice_item, 3, invoice_id: invoice_3.id, item_id: item_3.id, unit_price: item_3.unit_price, quantity: 3)

      [invoice_1, invoice_2, invoice_3].each do |invoice|
        create(:transaction, invoice_id: invoice.id)
      end

      x = 2

      top_items = Item.most_revenue(2)
      expect(top_items).to eq([item_2, item_3])
    end

    it 'returns the date YYYY-MM-DD for an item that has the most invoices and is the most recent' do
      item_1 = create(:item, unit_price: 2.1)
      item_2 = create(:item, unit_price: 3.5)

      invoice_1 = create(:invoice, merchant_id: item_1.merchant.id, created_at: '2012-03-27 14:54:09 UTC')
      invoice_2 = create(:invoice, merchant_id: item_2.merchant.id, created_at: '2012-03-08 20:54:10 UTC')
      invoice_3 = create(:invoice, merchant_id: item_1.merchant.id, created_at: '2012-03-27 14:54:09 UTC')

      create_list(:invoice_item, 3, invoice_id: invoice_1.id, item_id: item_1.id, unit_price: item_1.unit_price, quantity: 2, created_at: '2012-03-27 14:54:09 UTC')
      create_list(:invoice_item, 3, invoice_id: invoice_2.id, item_id: item_2.id, unit_price: item_2.unit_price, quantity: 4, created_at: '2012-03-08 20:54:10 UTC')
      create_list(:invoice_item, 3, invoice_id: invoice_3.id, item_id: item_1.id, unit_price: item_1.unit_price, quantity: 3, created_at: '2012-03-27 14:54:09 UTC')

      [invoice_1, invoice_2, invoice_3].each do |invoice|
        create(:transaction, invoice_id: invoice.id)
      end

      expect(item_1.best_day).to eq("2012-03-27")
      expect(item_2.best_day).to eq("2012-03-08")
    end
  end
end
