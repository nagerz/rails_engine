class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :description, :merchant_id, :name

  attribute :unit_price do |object|
    (object.unit_price/100.to_f).to_s
  end
end
