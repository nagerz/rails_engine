class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    # if params[:date]
    #   date = params[:date]
    # end
    render json: RevenueSerializer.new(MerchantRevenue.new(params[:date]))
  end

end
