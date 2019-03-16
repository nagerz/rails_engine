class Api::V1::Items::MostRevenueController < ApplicationController

  def index
    # if params[:quantity]
    #   limit = params[:quantity].to_i
    # end
    render json: ItemSerializer.new(Item.top_items_by_revenue(params[:quantity]))
  end

end
