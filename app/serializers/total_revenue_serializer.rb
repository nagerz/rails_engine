class TotalRevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :total_revenue do |object|
    "%.2f" % (object.revenue/100.to_f)
  end

end
