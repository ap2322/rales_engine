require 'csv'

desc "import invoices from csv file"
namespace :import do
  task :invoices => [:environment] do
    file = "db/csv_data/invoices.csv"

    CSV.foreach(file, :headers=> true) do |row|
      Invoice.create(row.to_h)
    end
  end
end
