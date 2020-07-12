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

  it 'can find an items that contain a fragment, case insensitive' do
    get '/api/v1/items/find?name=bob'
    json = JSON.parse(response.body, symbolize_names: true)
    name = json[:data][:attributes][:name].downcase

    expect(json[:data]).to be_a(Hash)
    expect(name).to include('bob')
  end


end






