class Api::V1::Items::RandomController < ApplicationController

  def show
    render json: ItemSerializer.new(Item.order("RANDOM()").first)
  end

end
