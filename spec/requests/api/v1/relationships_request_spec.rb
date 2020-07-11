require 'rails_helper'

describe "Relationships between Items and Merchants API" do
  it 'can get items for a merchant' do
    merchant1 = create(:merchant, id: 98)
    merchant2 = create(:merchant, id: 99)
    merchant3 = create(:merchant, id: 100)
    10.times do 
      create(:item, merchant: merchant1)
    end
    10.times do 
      create(:item, merchant: merchant2)
    end

    get '/api/v1/merchants/99/items'

    json = JSON.parse(response.body, symbolize_names: true)

    expected_ids = (11..20).to_a
    item_ids = json[:data].map do |item|
      item[:id].to_i
    end
    expect(item_ids.sort).to eq(expected_ids)
  end

  it 'can get merchant for an item' do
    create(:merchant, id: 10)
    create(:merchant, id: 11)
    create(:merchant, id: 12)
    create(:item, id: 209, merchant_id: 11)

    get '/api/v1/items/209/merchant'
    json = JSON.parse(response.body, symbolize_names: true)
    expected_id = '11'

    expect(json[:data][:id]).to eq(expected_id)
  end
end

# 
# end

# describe "search endpoints" do
# it 'can find a list of merchants that contain a fragment, case insensitive' do
# response = conn('/api/v1/merchants/find_all?name=ILL').get
# json = JSON.parse(response.body, symbolize_names: true)

# names = json[:data].map do |merchant|
#   merchant[:attributes][:name]
# end

# expect(names.sort).to eq(["Schiller, Barrows and Parker", "Tillman Group", "Williamson Group", "Williamson Group", "Willms and Sons"])
# end

# it 'can find a merchants that contain a fragment, case insensitive' do
# response = conn('/api/v1/merchants/find?name=ILL').get
# json = JSON.parse(response.body, symbolize_names: true)
# name = json[:data][:attributes][:name].downcase

# expect(json[:data]).to be_a(Hash)
# expect(name).to include('ill')
# end

# it 'can find a list of items that contain a fragment, case insensitive' do
# response = conn('/api/v1/items/find_all?name=haru').get
# json = JSON.parse(response.body, symbolize_names: true)

# names = json[:data].map do |merchant|
#   merchant[:attributes][:name].downcase
# end

# expect(names.count).to eq(18)
# names.each do |name|
#   expect(name).to include('haru')
# end
# end

# it 'can find an items that contain a fragment, case insensitive' do
# response = conn('/api/v1/items/find?name=haru').get
# json = JSON.parse(response.body, symbolize_names: true)
# name = json[:data][:attributes][:name].downcase

# expect(json[:data]).to be_a(Hash)
# expect(name).to include('haru')
# end
# end

# describe 'business intelligence' do
# it 'can get merchants with most revenue' do
# response = conn("/api/v1/merchants/most_revenue?quantity=7").get
# json = JSON.parse(response.body, symbolize_names: true)

# expect(json[:data].length).to eq(7)

# expect(json[:data][0][:attributes][:name]).to eq("Dicki-Bednar")
# expect(json[:data][0][:id]).to eq("14")

# expect(json[:data][3][:attributes][:name]).to eq("Bechtelar, Jones and Stokes")
# expect(json[:data][3][:id]).to eq("10")

# expect(json[:data][6][:attributes][:name]).to eq("Rath, Gleason and Spencer")
# expect(json[:data][6][:id]).to eq("53")
# end

# it 'can get merchants who have sold the most items' do
# response = conn("/api/v1/merchants/most_items?quantity=8").get

# json = JSON.parse(response.body, symbolize_names: true)

# expect(json[:data].length).to eq(8)

# expect(json[:data][0][:attributes][:name]).to eq("Kassulke, O'Hara and Quitzon")
# expect(json[:data][0][:id]).to eq("89")

# expect(json[:data][3][:attributes][:name]).to eq("Okuneva, Prohaska and Rolfson")
# expect(json[:data][3][:id]).to eq("98")

# expect(json[:data][7][:attributes][:name]).to eq("Terry-Moore")
# expect(json[:data][7][:id]).to eq("84")
# end

# it 'can get revenue between two dates' do
# response = conn('/api/v1/revenue?start=2012-03-09&end=2012-03-24').get

# json = JSON.parse(response.body, symbolize_names: true)

# expect(json[:data][:attributes][:revenue].to_f.round(2)).to eq(43201227.80)
# end
# end