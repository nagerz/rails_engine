class Api::V1::Customers::FavoriteMerchantController < ApplicationController

  def show
    render json: MerchantSerializer.new(Merchant.customer_favorite_merchant(params[:id]))
  end

end
