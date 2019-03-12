class Merchant < ApplicationRecord
  has_many :items, foreign_key: 'merchant_id'
  has_many :invoices, foreign_key: 'merchant_id'
end
