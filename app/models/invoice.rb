class Invoice < ApplicationRecord
  belongs_to :customer, foreign_key: 'customer_id'
  belongs_to :merchant, foreign_key: 'merchant_id'
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions
end
