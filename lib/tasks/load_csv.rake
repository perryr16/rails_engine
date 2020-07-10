require 'CSV'

desc "Print reminder about eating more fruit."
task :apple do
  puts "Eat more apples!"
end

desc "Load CSV files"
task :load_csv do 

customers = './data/customers.csv'
csv_import(customers)

invoice_items = './data/invoice_items.csv'
csv_import(invoice_items)

invoices = './data/invoices.csv'
csv_import(invoices)

items = './data/items.csv'
csv_import(items)

merchants = './data/merchants.csv'
csv_import(merchants)

transactions = './data/transactions.csv'
csv_import(transactions)

invoices = '/'
  

end

def csv_import(file)
  csv = File.read(file)
  CSV.parse(csv, headers: true).each do |row|
    binding.pry
  end
end


  # #turn list into array
  # def file_to_string_array
  #   card_list = []
  #   # File.open("./lib/two_cards.txt").each do |line|
  #     File.open(@filename).each do |line|
  #     card_list << line
  #   end
  #   card_list.each do |card|
  #     card.slice!("\n")
  #   end
  #   #@card_list
  # end