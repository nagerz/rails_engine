class Customer < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :first_name
  validates_presence_of :last_name


  def self.merchant_favorite_customer(merchant_id)
    select("customers.*, count(transactions) transaction_count")
    .joins(invoices: [:transactions])
    .merge(Transaction.successful)
    .where("invoices.merchant_id = ?", merchant_id)
    .group(:id)
    .order("transaction_count desc")
    .first
  end

  def self.merchant_pending_invoice_customers(merchant_id)
    # select("customers.*, count(transactions) transaction_count")
    # .joins(invoices: [:transactions])
    # .merge(Transaction.successful)
    # .where("invoices.merchant_id = ?", merchant_id)
    # .group(:id)
    # .order("transaction_count desc")
    # .first
  end

end
