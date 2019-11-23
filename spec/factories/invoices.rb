FactoryBot.define do
  factory :invoice do
    status { 1 }
    created_at {"2012-03-25 09:54:09"}
    updated_at {"2012-03-25 09:54:09"}
    association :customer, factory: :customer
    association :merchant, factory: :merchant
  end

  trait :with_invoice_items do
    transient do
      invoice_item_count { 2 }
    end

    after(:create) do |invoice, evaluator|
      invoice.invoice_items << create_list(:invoice_item, evaluator.invoice_item_count)
    end
  end

  trait :with_transactions do
    transient do
      transaction_count { 1 }
    end

    after(:create) do |invoice, evaluator|
      invoice.transactions << create_list(:transaction, evaluator.transaction_count)
    end
  end

end
