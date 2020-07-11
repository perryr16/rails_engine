require 'csv'
require './config/environment'

desc "Print reminder about eating more fruit."
task :apple do
  puts "Eat more apples!"
end

desc "Load CSV files"
task :load_csv, [:test] do |t, test|
  test.with_default(:test)
  test = test[:test] ||= ""

  Customer.destroy_all
  Merchant.destroy_all
  Item.destroy_all
  Invoice.destroy_all
  InvoiceItem.destroy_all
  Transaction.destroy_all
  # ActiveRecord::Base.connection.reset_pk_sequence!('customers')

  # customers_csv = "./data/customers.csv"
  customers_csv = "./data/customers#{test}.csv"
  build(customers_csv, Customer)

  # merchants_csv = "./data/merchants.csv"
  merchants_csv = "./data/merchants#{test}.csv"
  build(merchants_csv, Merchant)
  
  # items_csv = "./data/items.csv"
  items_csv = "./data/items#{test}.csv"
  build(items_csv, Item)

  invoices_csv = "./data/invoices#{test}.csv"
  build(invoices_csv, Invoice)
  
  invoice_items_csv = "./data/invoice_items#{test}.csv"
  build(invoice_items_csv, InvoiceItem)

  transactions_csv = "./data/transactions#{test}.csv"
  build(transactions_csv, Transaction)
  puts "Build complete"
  puts "Customer Count: #{Customer.all.count}"
  puts "Item Count: #{Item.all.count}"
  puts "Merchant Count: #{Merchant.all.count}"
end

def csv_import(file)
  csv = File.read(file)
  csv_rows = CSV.parse(csv, headers: true).map 
end

def build(file, model)
  csv_import(file).each do |row|
    unit_price(row) if row["unit_price"]
    model.create(row.to_hash)
  end
end


def unit_price(row)
  row["unit_price"] = (row["unit_price"].to_f/100).to_s
end