require 'csv'

desc "import customers from csv file"
namespace :import do
  task :customers => [:environment] do
    file = "db/csv_data/customers.csv"

    CSV.foreach(file, :headers=> true) do |row|
      Customer.create(row.to_h)
    end
  end
end
