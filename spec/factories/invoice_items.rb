FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    sequence :unit_price {|i| 0.5 + i }
    created_at {"2012-03-25 09:54:09"}
    updated_at {"2012-03-25 09:54:09"}
    association :item, factory: :item
    invoice
    FactoryBot.rewind_sequences
  end
end
