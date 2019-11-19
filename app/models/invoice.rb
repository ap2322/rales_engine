class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  enum status: %w(pending shipped)
end
