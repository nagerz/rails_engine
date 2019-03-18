class Api::V1::Merchants::RevenueController < ApplicationController

  def show
    render json: RevenueSerializer.new(MerchantRevenue.new(params[:date], params[:id]))
  end

  def index
    render json: TotalRevenueSerializer.new(MerchantRevenue.new(params[:date]))
  end

end
