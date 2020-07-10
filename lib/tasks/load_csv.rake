require 'csv'
require './config/environment'

desc "Print reminder about eating more fruit."
task :apple do
  puts "Eat more apples!"
end

desc "Load CSV files"
task :load_csv do 
  Customer.destroy_all
  Merchant.destroy_all
  Item.destroy_all
  Invoice.destroy_all
  InvoiceItem.destroy_all
  Transaction.destroy_all
  # ActiveRecord::Base.connection.reset_pk_sequence!('customers')

  customers_csv = './data/customers.csv'
  build(customers_csv, Customer)

  merchants_csv = './data/merchants.csv'
  build(merchants_csv, Merchant)
  
  items_csv = './data/items.csv'
  build(items_csv, Item)

  invoices_csv = './data/invoices.csv'
  build(invoices_csv, Invoice)
  
  invoice_items_csv = './data/invoice_items.csv'
  build(invoice_items_csv, InvoiceItem)

  transactions_csv = './data/transactions.csv'
  build(transactions_csv, Transaction)
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
