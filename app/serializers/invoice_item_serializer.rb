class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id, :item_id, :invoice_id

  attribute :quantity do |invoice_item|
    invoice_item.quantity.to_s
  end

  attribute :unit_price do |invoice_item|
    invoice_item.unit_price.to_s
  end

end
