class RevenueSerializer
  include FastJsonapi::ObjectSerializer

  attribute :total_revenue do |object|
    (object.revenue/100.to_f).to_s
  end

end
