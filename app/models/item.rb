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

  def best_day
    invoices
    .unscoped
    .joins(:transactions, :invoice_items)
    .merge(Transaction.unscoped.successful)
    .select("invoices.created_at::timestamp::date, sum(invoice_items.quantity) as sales")
    .group("invoices.created_at::timestamp::date, invoice_items.item_id")
    .having(invoice_items: {item_id: id})
    .order("sales desc, invoices.created_at::timestamp::date desc")
    .first
    .created_at
    .strftime("%F")
  end
end
