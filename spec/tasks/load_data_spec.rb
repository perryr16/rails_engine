require 'rails_helper'
require 'rake'
Rails.application.load_tasks


RSpec.describe "load_csv task" do

  it "values are empty" do
    expect(Customers.all.lenght).to eq(0)
    expect(InvoiceItems.all.lenght).to eq(0)
    expect(Invoices.all.lenght).to eq(0)
    expect(Items.all.lenght).to eq(0)
    expect(Merchants.all.lenght).to eq(0)
    expect(Transactions.all.lenght).to eq(0)
  end
  
  before :each do 
    Rake::Task[:load_csv].invoke
  end

  it "Customers Exist" do
    expect(Customer.all.count).to eq(1000)
    expect(Customer.first.id).to eq(1)
    expect(Customer.first.first_name).to eq("Joey")
    expect(Customer.first.last_name).to eq("Ondricka")
    expect(Customer.first.created_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Customer.first.updated_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Customer.last.first_name).to eq("Shawn")
    
  end
  


end