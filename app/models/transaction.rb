class Transaction < ApplicationRecord
  belongs_to :invoice

  validates_presence_of :credit_card_number
  enum result: %w(failed success)

  default_scope { order(id: :asc) }
  scope :successful, -> { where(result: 'success') }
end
