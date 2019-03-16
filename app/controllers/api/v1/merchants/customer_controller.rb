class Api::V1::Merchants::CustomerController < ApplicationController

  def show
    render json: CustomerSerializer.new(Customer.merchant_favorite_customer(params[:id]))
  end

end
