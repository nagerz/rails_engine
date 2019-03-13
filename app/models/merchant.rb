class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.top_merchants_by_revenue(limit)
    merchants_sorted_by_revenue.limit(limit)
  end

  def self.merchants_sorted_by_revenue
    select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) total_revenue")
    .joins(:invoice_items)
    .group(:id)
    .order("total_revenue desc")
  end
end
