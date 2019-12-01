class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates_presence_of :name, :description, :unit_price

  default_scope { order(id: :asc) }

  def self.most_revenue(limit_number)
    unscoped
    .joins(:transactions)
    .distinct
    .select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
    .group(:id)
    .order('revenue desc')
    .limit(limit_number)
  end
end
