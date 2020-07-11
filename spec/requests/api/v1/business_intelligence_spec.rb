require 'rails_helper'



describe 'business intelligence' do
  it 'can get merchants with most revenue' do
    customer = create(:customer)
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item = create(:item, merchant: merchant1)

    invoice11 = create(:invoice, merchant: merchant1, customer: customer)
    invoice12 = create(:invoice, merchant: merchant1, customer: customer)
    invoice13 = create(:invoice, merchant: merchant1, customer: customer)
    invoice21 = create(:invoice, merchant: merchant2, customer: customer)
    invoice22 = create(:invoice, merchant: merchant2, customer: customer)
    invoice23 = create(:invoice, merchant: merchant2, customer: customer)

    invoice_item = create(:invoice_item, item: item, invoice: invoice11)
    invoice_item = create(:invoice_item, item: item, invoice: invoice12)
    invoice_item = create(:invoice_item, item: item, invoice: invoice13)
    invoice_item = create(:invoice_item, item: item, invoice: invoice21)
    invoice_item = create(:invoice_item, item: item, invoice: invoice22)
    invoice_item = create(:invoice_item, item: item, invoice: invoice23)

    transaction = create(:transaction, invoice: invoice11, result: "success")
    transaction = create(:transaction, invoice: invoice12, result: "success")
    transaction = create(:transaction, invoice: invoice13, result: "success")
    transaction = create(:transaction, invoice: invoice21, result: "success")
    transaction = create(:transaction, invoice: invoice22, result: "success")
    transaction = create(:transaction, invoice: invoice23, result: "failed")

    get "/api/v1/merchants/most_revenue?quantity=7"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(7)

    expect(json[:data][0][:attributes][:name]).to eq("Dicki-Bednar")
    expect(json[:data][0][:id]).to eq("14")

    expect(json[:data][3][:attributes][:name]).to eq("Bechtelar, Jones and Stokes")
    expect(json[:data][3][:id]).to eq("10")

    expect(json[:data][6][:attributes][:name]).to eq("Rath, Gleason and Spencer")
    expect(json[:data][6][:id]).to eq("53")
  end

  it 'can get merchants who have sold the most items' do
    get "/api/v1/merchants/most_items?quantity=8"

    json = JSON.parse(response.body, symbolize_names: true)
    binding.pry

    expect(json[:data].length).to eq(8)

    expect(json[:data][0][:attributes][:name]).to eq("Kassulke, O'Hara and Quitzon")
    expect(json[:data][0][:id]).to eq("89")

    expect(json[:data][3][:attributes][:name]).to eq("Okuneva, Prohaska and Rolfson")
    expect(json[:data][3][:id]).to eq("98")

    expect(json[:data][7][:attributes][:name]).to eq("Terry-Moore")
    expect(json[:data][7][:id]).to eq("84")
  end

  xit 'can get revenue between two dates' do
    response = conn('/api/v1/revenue?start=2012-03-09&end=2012-03-24').get

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:attributes][:revenue].to_f.round(2)).to eq(43201227.80)
  end
end




# end