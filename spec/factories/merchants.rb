FactoryBot.define do
  factory :merchant do
    sequence :name {|i| "Merchant Bob #{i}" }
    FactoryBot.rewind_sequences
  end

  trait :with_invoices do
    transient do
      invoice_count { 3 }
    end

    after(:create) do |merchant, evaluator|
      evaluator.invoice_count.times do
        merchant.invoices << create(:invoice, :with_invoice_items, :with_transactions )
      end
    end
  end

  trait :with_items do
    transient do
      item_count { 3 }
    end

    after(:create) do |merchant, evaluator|
      merchant.items << create_list(:item, evaluator.item_count)
    end
  end
end
