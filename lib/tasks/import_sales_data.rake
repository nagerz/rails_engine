require 'csv'

task :import_sales_data => :environment do
  merchants_file = 'lib/data/merchants.csv'
  customers_file = 'lib/data/customers.csv'
  invoices_file = 'lib/data/invoices.csv'
  items_file = 'lib/data/items.csv'
  invoice_items_file = 'lib/data/invoice_items.csv'
  transactions_file = 'lib/data/transactions.csv'

  CSV.foreach(merchants_file, :headers => true) do |row|
    Merchant.create!(row.to_hash)
  end
  puts "#{Merchant.count} merchants have been created"

  CSV.foreach(customers_file, :headers => true) do |row|
    Customer.create!(row.to_hash)
  end
  puts "#{Customer.count} customers have been created"

  CSV.foreach(invoices_file, :headers => true) do |row|
    Invoice.create!(row.to_hash)
  end
  puts "#{Invoice.count} invoices have been created"

  CSV.foreach(items_file, :headers => true) do |row|
    Item.create!(row.to_hash)
  end
  puts "#{Item.count} items have been created"

  CSV.foreach(invoice_items_file, :headers => true) do |row|
    InvoiceItem.create!(row.to_hash)
  end
  puts "#{InvoiceItem.count} invoice_items have been created"

  CSV.foreach(transactions_file, :headers => true) do |row|
    Transaction.create!(row.to_hash)
  end
  puts "#{Transaction.count} transactions have been created"
end
