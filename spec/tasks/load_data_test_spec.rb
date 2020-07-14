require 'rails_helper'

Rails.application.load_tasks

RSpec.describe "load_csv task" do
  
  before :each do 
    Rake::Task[:load_csv].invoke("_test")
  end

  it "Models Created" do
    expect(Customer.all.count).to eq(16)
    expect(Customer.first.id).to eq(1)
    expect(Customer.first.first_name).to eq("Joey")
    expect(Customer.first.last_name).to eq("Ondricka")
    expect(Customer.first.created_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Customer.first.updated_at).to eq("2012-03-27 14:54:09 UTC")
    expect(Customer.last.first_name).to eq("Amara")
    # expect(Customer.first.invoices.present?).to eq(true)

    expect(Merchant.all.count).to eq(24)
    expect(Merchant.first.id).to eq(1)
    expect(Merchant.first.name).to eq("Schroeder-Jerde")
    expect(Merchant.first.created_at).to eq("2012-03-27 14:53:59 UTC")
    expect(Merchant.first.updated_at).to eq("2012-03-27 14:53:59 UTC")
    expect(Merchant.first.items.present?).to eq(true)
    
    expect(Item.all.count).to eq(25)
    expect(Item.first.id).to eq(1)
    expect(Item.first.name).to eq("Item Qui Esse")
    expect(Item.first.description).to eq("Nihil autem sit odio inventore deleniti. Est laudantium ratione distinctio laborum. Minus voluptatem nesciunt assumenda dicta voluptatum porro.")
    expect(Item.first.unit_price).to eq(751.07)
    expect(Item.first.merchant.name).to eq("Schroeder-Jerde")
    expect(Item.first.created_at).to eq("2012-03-27 14:53:59 UTC")
    expect(Item.first.updated_at).to eq("2012-03-27 14:53:59 UTC")
  end

end