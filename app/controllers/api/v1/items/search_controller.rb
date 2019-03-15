class Api::V1::Items::SearchController < ApplicationController

  def show
    render json: ItemSerializer.new(Item.find_by(search_params))
  end

  def index
    render json: ItemSerializer.new(Item.where(search_params))
  end

  private

  def search_params
    if params[:unit_price]
      params[:unit_price] = (100 * (params[:unit_price]).to_r).to_i
    end
    params.permit(:id, :merchant_id, :name, :description, :unit_price, :created_at, :updated_at)
  end
end
