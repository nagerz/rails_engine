class Api::V1::Items::BestDayController < ApplicationController

  def show
    render json: BestDaySerializer.new(ItemBestDay.new(params[:id]))
  end

end
