desc "import all csv files"
namespace :import do
  task :all => [:merchants, :items, :customers, :invoices]
end
