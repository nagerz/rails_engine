class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    if params[:date]
      date = params[:date]
    end
    revenue = Merchant.merchants_total_revenue_date(date)
    render json: revenue
  end

end
