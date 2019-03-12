class Api::V1::Merchants::MostRevenueController < ApplicationController

  def index
    limit = params[:quantity].to_i
    merchants = Merchant.top_merchants_by_revenue(limit)
    render json: merchants
  end

end
