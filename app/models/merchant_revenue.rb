class MerchantRevenue
  attr_reader :revenue, :id

  def initialize(date)
    @revenue = Merchant.merchants_total_revenue_date(date)
  end
end
