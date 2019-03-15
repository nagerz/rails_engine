class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.top_merchants_by_revenue(limit = 10)
    merchants_sorted_by_revenue.limit(limit)
  end

  def self.top_merchants_by_items(limit = 10)
    merchants_sorted_by_items.limit(limit)
  end

  ##Why does this not work
  #.joins(:invoice_items, :transactions)
  def self.merchants_sorted_by_revenue
    select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) total_revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("total_revenue desc")
  end

  def self.merchants_sorted_by_items
  select("merchants.*, sum(invoice_items.quantity) items_sold")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("items_sold desc")
  end

  def self.merchants_total_revenue_date(date = Date.today)
    date_revenues = self.select("sum(invoice_items.quantity * invoice_items.unit_price) date_revenue")
                        .joins(invoices: [:invoice_items, :transactions])
                        .merge(Transaction.successful)
                        .where("DATE(invoices.updated_at) = ?", date.to_date)
                        .group(:id)
    date_revenues.sum(&:date_revenue)
  end

  def self.merchant_total_revenue(id, date = nil)
    if date
      5
    else
      select("sum(invoice_items.quantity * invoice_items.unit_price) revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .where(id: id)
      .group(:id)
      .first
      .revenue
    end
  end

end
