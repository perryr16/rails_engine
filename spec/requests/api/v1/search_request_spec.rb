require 'rails_helper'

describe "Search Endpoints for Merchants" do
  before :each do 
    create(:merchant, name: 'chill zone')
    create(:merchant, name: 'THRILL zone')
    create(:merchant, name: 'hammers and drIlLs')
    create(:merchant, name: 'nothing')
    create(:merchant, name: 'lilililili')

  end
  it 'can find a list of merchants that contain a fragment, case insensitive' do
    
    get '/api/v1/merchants/find_all?name=ILL'
    json = JSON.parse(response.body, symbolize_names: true)
    
    names = json[:data].map do |merchant|
      merchant[:attributes][:name]
    end
    expect(names.sort).to eq(["THRILL zone", "chill zone", "hammers and drIlLs"])
  end

  it 'can find a merchant that contain a fragment, case insensitive' do

    get '/api/v1/merchants/find?name=ILL'
    json = JSON.parse(response.body, symbolize_names: true)

    name = json[:data][:attributes][:name].downcase

    expect(json[:data]).to be_a(Hash)
    expect(name).to include('ill')
  end
end

describe "Search endpoints for Items"do
  before :each do 
    merchant = create(:merchant)
    create(:item, merchant: merchant, name: "BOBS item")
    create(:item, merchant: merchant, name: "bob bob bob")
    create(:item, merchant: merchant, name: "Strawberry and rhubob")
    create(:item, merchant: merchant, name: "bo bo bo")
    create(:item, merchant: merchant, name: "not valid")\
  end

  it 'can find a list of items that contain a fragment, case insensitive' do
    get '/api/v1/items/find_all?name=bob'
    json = JSON.parse(response.body, symbolize_names: true)

    names = json[:data].map do |merchant|
      merchant[:attributes][:name].downcase
    end

    expect(names.count).to eq(3)
    names.each do |name|
      expect(name).to include('bob')
    end
  end


end






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