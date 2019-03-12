require 'csv'

namespace :import_merchants do
  task :create_merchants => :environment do
    merchants_file = 'lib/data/merchants.csv'

    CSV.foreach(merchants_file, :headers => true) do |row|
      Merchant.create!(row.to_hash)
    end
  end
end
