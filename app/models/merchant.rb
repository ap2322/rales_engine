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
    # .where(transactions: {result: 'success'})
  end

  def self.revenue(date)
    joins(:invoice_items)
    .select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue, invoices.created_at::timestamp::date")
    .group("invoices.created_at::timestamp::date")
    .where("invoices.created_at::timestamp::date = ?, #{date}")

      # > created_at.beginning_of_day
      # < created_at.end_of_day
# Merchant.joins(:invoice_items).select("sum(invoice_items.quantity * invoice_items.unit_price) as revenue, invoices.created_at::timestamp::date").group("invoices.created_at::timestamp::date").order("invoices.created_at::timestamp::date")
# SELECT sum(invoice_items.quantity * invoice_items.unit_price) as revenue, invoice_items.created_at::timestamp::date FROM "merchants" INNER JOIN "invoices" ON "invoices"."merchant_id" = "merchants"."id" INNER JOIN "invoice_items" ON "invoice_items"."invoice_id" = "invoices"."id" GROUP BY invoice_items.created_at::timestamp::date;
  end
end
