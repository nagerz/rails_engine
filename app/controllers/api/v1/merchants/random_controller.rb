class Api::V1::Merchants::RandomController < ApplicationController

  def show
    render json: MerchantSerializer.new(Merchant.order("RANDOM()").first)
  end

end
