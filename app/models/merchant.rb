class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.most_revenue(x)
    joins(:invoice_items, :transactions)
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order("revenue desc")
    .limit(x)
    # .merge(Transaction.unscoped.successful)
  end

  def self.revenue(date)
    date_revenue_total = joins(:invoice_items, "INNER JOIN transactions ON transactions.invoice_id = invoices.id")
    .select("sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue, invoices.created_at::timestamp::date")
    .merge(Transaction.unscoped.successful)
    .group("invoices.created_at::timestamp::date")
    .having("invoices.created_at::timestamp::date = ?", date)
    .sum("invoice_items.quantity * invoice_items.unit_price")
    date_revenue_total[date.to_date]

    # joins(:invoice_items, :transactions).select("sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue, invoices.created_at::timestamp::date").group("invoices.created_at::timestamp::date").where("invoices.created_at::timestamp::date = ?", date).sum("invoice_items.quantity * invoice_items.unit_price")
    # Merchant.joins(:invoice_items, "INNER JOIN transactions ON transactions.invoice_id = invoices.id").select("sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue, invoices.created_at::timestamp::date").merge(Transaction.unscoped.successful).group("invoices.created_at::timestamp::date").having("invoices.created_at::timestamp::date = ?", "2012-03-16")
  end
end
