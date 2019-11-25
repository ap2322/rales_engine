FactoryBot.define do
  factory :merchant do
    sequence :name {|i| "Merchant Bob #{i}" }
    FactoryBot.rewind_sequences
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
