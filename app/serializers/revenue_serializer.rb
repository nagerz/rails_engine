class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :revenue do |object|
    "%.2f" % (object.revenue/100.to_f)
  end

end
