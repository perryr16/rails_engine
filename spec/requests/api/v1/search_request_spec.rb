require 'rails_helper'

describe "Search Endpoints for Merchants" do
  before :each do 
    merchant = create(:merchant, name: 'chill zone')
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
    create(:item, merchant: merchant, name: "BOBS item", description: "nope", updated_at: '2012-03-27 14:58:03 UTC')
    create(:item, merchant: merchant, name: "bob bob bob", description: "xCATx", updated_at: '2012-03-27 14:58:03 UTC' )
    create(:item, merchant: merchant, name: "Strawberry and rhubob", description: "cars")
    create(:item, merchant: merchant, name: "bo bo bo", description: "adfadfcAtcat", updated_at: '2012-03-27 14:58:03 UTC')
    create(:item, merchant: merchant, name: "not valid", description: "cat")
    create(:item, merchant: merchant, name: "dog", description: "DOG")
  end

  it 'can find a list of items that contain a fragment, case insensitive of name' do
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

  it 'can find an items that contain a fragment, case insensitive of name' do
    get '/api/v1/items/find?name=bob'
    json = JSON.parse(response.body, symbolize_names: true)
    name = json[:data][:attributes][:name].downcase

    expect(json[:data]).to be_a(Hash)
    expect(name).to include('bob')
  end

  it 'can find a list of items that contain a fragment, case insensitive of description' do
    get '/api/v1/items/find_all?description=cAt'
    json = JSON.parse(response.body, symbolize_names: true)

    descriptions = json[:data].map do |merchant|
      merchant[:attributes][:description].downcase
    end

    expect(descriptions.count).to eq(3)
    descriptions.each do |description|
      expect(description).to include('cat')
    end
  end

  it 'can find a list of items that contain a fragment, case insensitive of description OR name' do
    get '/api/v1/items/find_all?description=cAt&name=BOB'
    json = JSON.parse(response.body, symbolize_names: true)
    
    descriptions_and_names = json[:data].map do |item|
      [item[:attributes][:description].downcase, item[:attributes][:name].downcase].join
    end

    expect(json[:data].count).to eq(5)

    descriptions_and_names.each do |attribute|
        expect(attribute).to include('bob').or include('cat')
    end
  end

  it 'can find a one item that contain a fragment, case insensitive of description OR name' do
    get '/api/v1/items/find?description=cAt&name=BOB'
    json = JSON.parse(response.body, symbolize_names: true)
    attributes = json[:data][:attributes]
    description_and_name = "#{attributes[:name].downcase} " +
                            "#{attributes[:description].downcase}"
  

    expect(json[:data].class).to eq(Hash)
    expect(description_and_name).to include('cat').or include('bob')

  end


end






