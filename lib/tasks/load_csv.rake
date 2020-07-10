require 'CSV'
require './config/environment'

desc "Print reminder about eating more fruit."
task :apple do
  puts "Eat more apples!"
end

desc "Load CSV files"
task :load_csv do 
  Customer.destroy_all
  Merchant.destroy_all
  # ActiveRecord::Base.connection.reset_pk_sequence!('customers')

  customers_csv = './data/customers.csv'
  build(customers_csv, Customer)

  # invoice_items = './data/invoice_items.csv'
  # build(invoice_items)

  # invoices = './data/invoices.csv'
  # build(invoices)

  # items = './data/items.csv'
  # build(items)

  merchants_csv = './data/merchants.csv'
  build(merchants_csv, Merchant)

  # transactions = './data/transactions.csv'
  # build(transactions)
  binding.pry
end

def csv_import(file)
  csv = File.read(file)
  csv_rows = CSV.parse(csv, headers: true).map 
end

def build(file, model)
  csv_import(file).each do |row|
    model.create(row.to_hash)
  end
end

def customer_params(row)
  {first_name: row["first_name"], last_name: row["last_name"],
  created_at: row["created_at"], updated_at: row["updated_at"]}
end

def merchant_params(row)
  {name: row["name"],
  created_at: row["created_at"], updated_at: row["updated_at"]}
end

# def build_params(row)
#   params = {}
#   row.each do |k,v|
#     params[k] = v if k != "id"
#   end
#   params
# end
