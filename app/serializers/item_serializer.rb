class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :description, :merchant_id, :name

  attribute :unit_price do |object|
    "%.2f" % (object.unit_price/100.to_f)
  end
end
