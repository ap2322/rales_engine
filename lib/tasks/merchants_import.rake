require 'csv'

desc "import merchants from csv file"
namespace :import do
  task :merchants => [:environment] do
    file = "db/csv_data/merchants.csv"

    CSV.foreach(file, :headers=> true) do |row|
      Merchant.create(row.to_h)
    end
  end
end
