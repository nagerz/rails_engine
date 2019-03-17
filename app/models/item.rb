class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.top_items_by_revenue(limit = 10)
    items_sorted_by_revenue.limit(limit.to_i)
  end

  def self.top_items_by_volume(limit = 10)
    items_sorted_by_volume.limit(limit.to_i)
  end

  def self.items_sorted_by_revenue
    select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) total_revenue")
    .joins(invoices: [:transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("total_revenue desc")
  end

  def self.items_sorted_by_volume
  select("items.*, sum(invoice_items.quantity) volume")
    .joins(invoices: [:transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("volume desc")
  end

  def self.best_day(item_id)
    
  end
end
