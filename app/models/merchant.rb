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

  def self.merchant_total_revenue(merchant_id, date = nil)
    if date
      select("sum(invoice_items.quantity * invoice_items.unit_price) revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .where(id: merchant_id)
      .where("DATE(invoices.updated_at) = ?", date.to_date)
      .group(:id)
      .first
      .revenue
    else
      select("sum(invoice_items.quantity * invoice_items.unit_price) revenue")
      .joins(invoices: [:invoice_items, :transactions])
      .merge(Transaction.successful)
      .where(id: merchant_id)
      .group(:id)
      .first
      .revenue
    end
  end

  def self.customer_favorite_merchant(customer_id)
    select("merchants.*, count(transactions) transaction_count")
    .joins(invoices: [:transactions])
    .merge(Transaction.successful)
    .where("invoices.customer_id = ?", customer_id)
    .group(:id)
    .order("transaction_count desc")
    .first
  end

end
