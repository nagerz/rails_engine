class Api::V1::Merchants::MostItemsController < ApplicationController

  def index
    limit = params[:quantity].to_i
    merchants = Merchant.top_merchants_by_items(limit)
    render json: merchants
  end

end
