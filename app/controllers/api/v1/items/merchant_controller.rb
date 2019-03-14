class Api::V1::Items::MerchantController < ApplicationController

  def show
    item = Item.find(params[:id])
    render json: item.merchant
  end

end
