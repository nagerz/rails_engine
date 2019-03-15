class Api::V1::Merchants::RevenueController < ApplicationController

  def show
    render json: RevenueSerializer.new(MerchantRevenue.new(params[:date], params[:id]))
  end

  def index
    # if params[:date]
    #   date = params[:date]
    # end
    render json: RevenueSerializer.new(MerchantRevenue.new(params[:date]))
  end

end
