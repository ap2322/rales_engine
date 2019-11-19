require 'csv'

desc "import invoice_items from csv file"
namespace :import do
  task :invoice_items => [:environment] do
    file = "db/csv_data/invoice_items.csv"

    CSV.foreach(file, :headers=> true) do |row|
      invoice_item_hash = row.to_h
      dollars = invoice_item_hash["unit_price"].to_f / 100
      invoice_item_hash["unit_price"] = dollars
      InvoiceItem.create(invoice_item_hash)
    end
  end
end
