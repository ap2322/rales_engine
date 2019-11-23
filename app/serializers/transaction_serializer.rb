class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :credit_card_number, :result, :invoice_id

  attributes :credit_card_expiration_date do |transaction|
    transaction.credit_card_expiration_date.to_s
  end

end
