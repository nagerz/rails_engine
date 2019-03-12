class Customer < ApplicationRecord
  has_many :invoices, foreign_key: 'customer_id'
  
end
