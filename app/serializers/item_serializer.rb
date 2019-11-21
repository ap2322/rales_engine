class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  set_id :merchant_id

  attributes :unit_price do |item|
    item.unit_price.to_s
  end

  belongs_to :merchant
end
