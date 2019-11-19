require 'csv'

desc "import transactions from csv file"
namespace :import do
  task :transactions => [:environment] do
    file = "db/csv_data/transactions.csv"

    CSV.foreach(file, :headers=> true) do |row|
      Transaction.create(row.to_h)
    end
  end
end
