FactoryBot.define do
  trait :with_invoice_items do
    transient do
      invoice_item_count { 2 }
    end

    after(:create) do |object, evaluator|
      object.invoice_items << create_list(:invoice_item, evaluator.invoice_item_count)
    end
  end


  trait :with_invoices do
    transient do
      invoice_count { 3 }
    end

    after(:create) do |object, evaluator|
      evaluator.invoice_count.times do
        object.invoices << create(:invoice, :with_invoice_items, :with_transactions )
      end
    end
  end

end
