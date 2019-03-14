class Api::V1::Invoices::CustomerController < ApplicationController

  def show
    invoice = Invoice.find(params[:id])
    render json: invoice.customer
  end

end
