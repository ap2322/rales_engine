class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of :name, :description, :unit_price

  def self.most_revenue(x)
    joins(:transactions)
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .where(transactions:{result: 'success'})
    .order("revenue desc")
    .limit(x)
  end
end
