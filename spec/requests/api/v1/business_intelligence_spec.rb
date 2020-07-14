require 'rails_helper'



describe 'business intelligence' do
  before :each do 
    FactoryBot.reload
    customer = create(:customer)
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @merchant4 = create(:merchant)

    item1 = create(:item, merchant: @merchant1)
    item2 = create(:item, merchant: @merchant2)
    item3 = create(:item, merchant: @merchant3)
    item4 = create(:item, merchant: @merchant4)

    invoice11 = create(:invoice, merchant: @merchant1, customer: customer, updated_at: 'Sun, 19 Jul 2021 18:08:20 UTC +00:00')
    invoice12 = create(:invoice, merchant: @merchant1, customer: customer)
    invoice13 = create(:invoice, merchant: @merchant1, customer: customer)
    invoice21 = create(:invoice, merchant: @merchant2, customer: customer)
    invoice22 = create(:invoice, merchant: @merchant2, customer: customer)
    invoice23 = create(:invoice, merchant: @merchant2, customer: customer)
    invoice31 = create(:invoice, merchant: @merchant3, customer: customer)
    invoice32 = create(:invoice, merchant: @merchant3, customer: customer)
    invoice33 = create(:invoice, merchant: @merchant3, customer: customer)
    invoice41 = create(:invoice, merchant: @merchant4, customer: customer)

    invoice_item = create(:invoice_item, item: item1, invoice: invoice11, quantity: 100, unit_price: 0.01)
    invoice_item = create(:invoice_item, item: item1, invoice: invoice12, quantity: 100, unit_price: 0.01)
    invoice_item = create(:invoice_item, item: item1, invoice: invoice13, quantity: 100, unit_price: 0.01)
    invoice_item = create(:invoice_item, item: item2, invoice: invoice21, quantity: 100, unit_price: 10)
    invoice_item = create(:invoice_item, item: item2, invoice: invoice22, quantity: 1, unit_price: 1)
    invoice_item = create(:invoice_item, item: item2, invoice: invoice23, quantity: 1, unit_price: 1)
    invoice_item = create(:invoice_item, item: item3, invoice: invoice31, quantity: 100, unit_price: 1)
    invoice_item = create(:invoice_item, item: item3, invoice: invoice32, quantity: 30, unit_price: 1)
    invoice_item = create(:invoice_item, item: item3, invoice: invoice33, quantity: 66, unit_price: 1)
    invoice_item = create(:invoice_item, item: item4, invoice: invoice41, quantity: 1, unit_price: 0.5)

    transaction = create(:transaction, invoice: invoice11, result: "success")
    transaction = create(:transaction, invoice: invoice12, result: "success")
    transaction = create(:transaction, invoice: invoice13, result: "success")
    transaction = create(:transaction, invoice: invoice21, result: "success")
    transaction = create(:transaction, invoice: invoice22, result: "success")
    transaction = create(:transaction, invoice: invoice23, result: "failed")
    transaction = create(:transaction, invoice: invoice31, result: "success")
    transaction = create(:transaction, invoice: invoice32, result: "success")
    transaction = create(:transaction, invoice: invoice33, result: "success")
    transaction = create(:transaction, invoice: invoice41, result: "success")
  end
  it 'can get merchants with most revenue' do
    

    get "/api/v1/merchants/most_revenue?quantity=3"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(3)

    expect(json[:data][0][:attributes][:name]).to eq(@merchant2.name)
    expect(json[:data][0][:id]).to eq("2")

    expect(json[:data][1][:attributes][:name]).to eq(@merchant3.name)
    expect(json[:data][1][:id]).to eq("3")

    expect(json[:data][2][:attributes][:name]).to eq(@merchant1.name)
    expect(json[:data][2][:id]).to eq("1")
  end

  it 'can get merchants who have sold the most items' do
    get "/api/v1/merchants/most_items?quantity=2"

    json = JSON.parse(response.body, symbolize_names: true)


    expect(json[:data].length).to eq(2)

    expect(json[:data][0][:attributes][:name]).to eq(@merchant1.name)
    expect(json[:data][0][:id]).to eq("1")

    expect(json[:data][1][:attributes][:name]).to eq(@merchant3.name)
    expect(json[:data][1][:id]).to eq("3")
  end

  it 'can get revenue between two dates' do
    get '/api/v1/revenue?start=2000-01-01&end=2021-07-15'

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:attributes][:revenue].to_f.round(2)).to eq(1200.50)
  end

  it 'can get revenue for one merchant between two dates' do
    get "/api/v1/merchants/#{@merchant1.id}/revenue"

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:attributes][:revenue].to_f.round(2)).to eq(2.0)
  end
end




# end