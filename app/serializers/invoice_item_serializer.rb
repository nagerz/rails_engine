class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :invoice_id, :item_id, :quantity, :unit_price

  attribute :unit_price do |object|
    "%.2f" % (object.unit_price/100.to_f)
  end
end
