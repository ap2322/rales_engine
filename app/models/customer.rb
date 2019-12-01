class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    merchants
    .joins(:transactions)
    .select("merchants.*, count(invoices.merchant_id) as purchases")
    .where(transactions: {result: 'success'}, invoices: {customer_id: id})
    .group("merchants.id, invoices.id")
    .reorder(nil)
    .order("purchases desc")
    .first
  end
end
