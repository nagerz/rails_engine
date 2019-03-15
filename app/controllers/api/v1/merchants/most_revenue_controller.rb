class Api::V1::Merchants::MostRevenueController < ApplicationController

  def index
    if params[:quantity]
      limit = params[:quantity].to_i
    end
    merchants = Merchant.top_merchants_by_revenue(limit)
    render json: MerchantSerializer.new(merchants)
  end

end
