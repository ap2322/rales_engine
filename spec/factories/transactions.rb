FactoryBot.define do
  factory :transaction do
    sequence :credit_card_number {|i| "4000#{i}" }
    credit_card_expiration_date { "2019-11-19" }
    result { 1 }
    created_at {"2012-03-25 09:54:09"}
    updated_at {"2012-03-25 09:54:09"}

    invoice
  end

end
