require 'csv'

desc "import items from csv file"
task :import => [:environment] do
  file = "db/csv_data/items.csv"

  CSV.foreach(file, :headers=> true) do |row|
    # Item.create({
    #   name: row
    #   })
  end
end
