require 'rails_helper'
require 'rake'
Rails.application.load_tasks

RSpec.describe "load_csv task" do
  
  before :each do 
    Rake::Task[:load_csv].invoke
  end

  xit "Customers Created" do
    expect(Customer.all.count).to eq(1000)
    expect(Customer.first.id).to eq(1)
    expect(Customer.first.first_name).to eq("Joey")
    expect(Customer.first.last_name).to eq("Ondricka")
    expect(Customer.first.created_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Customer.first.updated_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Customer.last.first_name).to eq("Shawn")
    # expect(Customer.first.invoices.present?).to eq(true)

    expect(Merchant.all.count).to eq(100)
    expect(Merchant.first.id).to eq(1)
    expect(Merchant.first.name).to eq("Schroeder-Jerde")
    expect(Merchant.first.created_at).to eq("2012-03-27 14:53:59 UTC")
    expect(Merchant.first.updated_at).to eq("2012-03-27 14:53:59 UTC")
    expect(Merchant.first.items.present?).to eq(true)
    
    expect(Item.all.count).to eq(2483)
    expect(Item.first.id).to eq(1)
    expect(Item.first.name).to eq("Item Qui Esse")
    expect(Item.first.description).to eq("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.")
    expect(Item.first.unit_price).to eq(75107)
    expect(Item.first.merchant.name).to eq("Schroeder-Jerde")
    expect(Item.first.created_at).to eq("2012-03-27 14:53:59 UTC")
    expect(Item.first.updated_at).to eq("2012-03-27 14:53:59 UTC")

    expect(Invoice.all.count).to eq(4843)
    expect(Invoice.first.id).to eq(1)
    expect(Invoice.first.customer.first_name).to eq("Joey")
    expect(Invoice.first.merchant.name).to eq("Balistreri, Schaefer and Kshlerin")
    expect(Invoice.first.status).to eq("shipped")
    expect(Invoice.first.created_at).to eq("2012-03-25 09:54:09 UTC")
    expect(Invoice.first.updated_at).to eq("2012-03-25 09:54:09 UTC")

    expect(InvoiceItem.all.count).to eq(21687)
    expect(InvoiceItem.first.item.id).to eq(539)
    expect(InvoiceItem.first.invoice.id).to eq(1)
    expect(InvoiceItem.first.quantity).to eq(5)
    expect(InvoiceItem.first.unit_price).to eq(13635)
    expect(InvoiceItem.first.created_at).to eq("2012-03-27 14:54:09 UTC")
    expect(InvoiceItem.first.updated_at).to eq("2012-03-27 14:54:09 UTC")

    expect(Transaction.all.count).to eq(5595)
    expect(Transaction.first.id).to eq(1)
    expect(Transaction.first.invoice.id).to eq(1)
    expect(Transaction.first.credit_card_number).to eq("4654405418249632")
    expect(Transaction.first.credit_card_expiration_date).to eq(nil)
    expect(Transaction.first.result).to eq("success")
    expect(Transaction.first.created_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Transaction.first.updated_at).to eq("2012-03-27 14:54:09 UTC")
  end

end