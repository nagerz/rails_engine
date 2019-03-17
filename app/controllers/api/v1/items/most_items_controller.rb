class Api::V1::Items::MostItemsController < ApplicationController

  def index
    # if params[:quantity]
    #   limit = params[:quantity].to_i
    # end
    render json: ItemSerializer.new(Item.top_items_by_volume(params[:quantity]))
  end

end
