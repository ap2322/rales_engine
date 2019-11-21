FactoryBot.define do
  factory :transaction do
    sequence :credit_card_number {|i| "4000#{i}" }
    credit_card_expiration_date { "2019-11-19" }
    result { 1 }
    invoice
  end

end
