FactoryBot.define do
  trait :with_invoice_items do
    transient do
      invoice_item_count { 2 }
    end

    after(:create) do |object, evaluator|
      object.invoice_items << create_list(:invoice_item, evaluator.invoice_item_count)
    end
  end
end
