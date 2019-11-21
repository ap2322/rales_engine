FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    sequence :unit_price {|i| 0.5 + i }
    item
    invoice
    FactoryBot.rewind_sequences
  end
end
