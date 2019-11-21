class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attributes :unit_price do |item|
    item.unit_price.to_s
  end

end
