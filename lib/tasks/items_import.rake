require 'csv'

desc "import items from csv file"
task :import => [:environment] do
  file = "db/csv_data/items.csv"

  CSV.foreach(file, :headers=> true) do |row|
    item_hash = row.to_h
    dollars = item_hash["unit_price"].to_f / 100
    item_hash["unit_price"] = dollars
    Item.create(item_hash)
  end
end
