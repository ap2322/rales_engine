FactoryBot.define do
  factory :merchant do
    sequence :name {|i| "Merchant Bob #{i}" }
  end
end
