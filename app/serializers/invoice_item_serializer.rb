class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id, :item_id, :invoice_id, :quantity

  attribute :unit_price do |invoice_item|
    invoice_item.unit_price.to_s
  end

end
