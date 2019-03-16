class Api::V1::Merchants::PendingInvoiceCustomersController < ApplicationController

  def index
    render json: CustomerSerializer.new(Customer.merchant_pending_invoice_customers(params[:id]))
  end

end
