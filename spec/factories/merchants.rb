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
      merchant.invoices << create_list( :invoice, evaluator.invoice_count, :with_invoice_items, :with_transactions )
    end
  end

end
