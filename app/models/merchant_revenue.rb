class MerchantRevenue
  attr_reader :revenue, :id

  def initialize(date, id = nil)
    if id
      @revenue = Merchant.merchant_total_revenue(id, date)
    else
      @revenue = Merchant.merchants_total_revenue_date(date)
    end
  end
end
