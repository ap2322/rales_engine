class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  enum status: %w(pending shipped)

  default_scope { order(id: :asc) }

end
