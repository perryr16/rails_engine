require 'rails_helper'

describe "Search Endpoints for Merchants" do
  before :each do 
    @merchant = create(:merchant, name: 'chill zone', updated_at: '2015-05-25 12:58:03 UTC')
    @merchant2 = create(:merchant, name: 'hammers and drIlLs', updated_at: '2014-04-24 10:58:03 UTC')
    @merchant3 = create(:merchant, name: 'THRILL zone', updated_at: '2016-06-26 14:58:03 UTC')
    @merchant4 = create(:merchant, name: 'nothing', created_at: '2016-06-26 14:58:03 UTC')
    @merchant5 = create(:merchant, name: 'lilililili')
    
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

  it 'can find a merchant based on date of updated_at' do
    get "/api/v1/merchants/find?updated_at=2016"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].class).to eq(Hash)

    expect(json[:data][:attributes][:name]).to eq(@merchant3.name)
  end

  it 'can find a merchant based on date of created_at' do
    get "/api/v1/merchants/find?created_at=2016"
    json = JSON.parse(response.body, symbolize_names: true)
    
    expect(json[:data].class).to eq(Hash)

    expect(json[:data][:attributes][:name]).to eq(@merchant4.name)
  end
  it 'can find a merchant based on EXACT date of created_at' do
    get "/api/v1/merchants/find?created_at=#{@merchant.created_at}"
    json = JSON.parse(response.body, symbolize_names: true)
    
    expect(json[:data].class).to eq(Hash)

    expect(json[:data][:attributes][:name]).to eq(@merchant.name)
  end

  it 'can find a merchant based on date of updated_at and fragment of name' do
    get "/api/v1/merchants/find_all?updated_at=12&name=zone"
    json = JSON.parse(response.body, symbolize_names: true)
    

    expect(json[:data].class).to eq(Array)

    expect(json[:data][0][:attributes][:name]).to eq('chill zone')
  end

  it 'SAD: cant find a merchant based on date that does not exist' do
    get "/api/v1/merchants/find_all?updated_at=12&name=21adf434"
    json = JSON.parse(response.body, symbolize_names: true)
    
    expect(json[:data].class).to eq(Array)

    expect(json[:data].empty?).to eq(true)
  end
  

end

describe "Search endpoints for Items"do
  before :each do 
    merchant = create(:merchant)
    @item1 = create(:item, merchant: merchant, name: "BOBS item", description: "nope", updated_at: '2015-03-27 14:58:03 UTC', unit_price: 1.23)
    @item2 = create(:item, merchant: merchant, name: "bob bob bob", description: "xCATx", updated_at: '2012-03-27 14:58:03 UTC' )
    @item3 = create(:item, merchant: merchant, name: "Strawberry and rhubob", description: "cars", updated_at: '2015-03-27 14:58:05 UTC')
    @item4 = create(:item, merchant: merchant, name: "bo bo bo", description: "adfadfcAtcat", updated_at: '2012-03-27 14:58:03 UTC')
    @item5 = create(:item, merchant: merchant, name: "not valid", description: "cat")
    @item6 = create(:item, merchant: merchant, name: "dog", description: "DOG", unit_price: 23.99)
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

  it 'can find a list of items that contain a fragment, case insensitive of description AND name' do
    get '/api/v1/items/find_all?description=cAt&name=BOB'
    json = JSON.parse(response.body, symbolize_names: true)
    
    descriptions_and_names = json[:data].map do |item|
      [item[:attributes][:description].downcase, item[:attributes][:name].downcase].join
    end

    expect(json[:data].count).to eq(1)

    descriptions_and_names.each do |attribute|
        expect(attribute).to include('bob').and include('cat')
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

  it 'can find a list of items based on date of updated_at' do
    get "/api/v1/items/find_all?updated_at=2015"
    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data].class).to eq(Array)


    expect(json[:data][0][:attributes][:name]).to eq(@item1.name)
    expect(json[:data][1][:attributes][:name]).to eq(@item3.name)
    expect(json[:data].count).to eq(2)
  end

  it 'can find a item based on date of created_at' do
    get "/api/v1/items/find?created_at=2020"
    json = JSON.parse(response.body, symbolize_names: true)
    

    expect(json[:data].class).to eq(Hash)

    expect(json[:data][:attributes][:name]).to eq(@item1.name)
  end

  it 'can find a item based on date of updated_at' do
    get "/api/v1/items/find?updated_at=14:58"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].class).to eq(Hash)

    expect(json[:data][:attributes][:name]).to eq(@item1.name)
  end

  it 'can find a list of items based on date of updated_at and fragment of name' do
    get "/api/v1/items/find_all?updated_at=2012&description=cat"
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].class).to eq(Array)
    
    expect(json[:data][0][:attributes][:name]).to eq(@item2.name)
    expect(json[:data][1][:attributes][:name]).to eq(@item4.name)

 
    expect(json[:data].count).to eq(2)
  end
  it 'can find a list of items based on date of updated_at and fragment of name' do
    get "/api/v1/items/find_all?unit_price=23"
    json = JSON.parse(response.body, symbolize_names: true)
    
    expect(json[:data].class).to eq(Array)
    
    expect(json[:data][0][:attributes][:name]).to eq(@item1.name)
    expect(json[:data][1][:attributes][:name]).to eq(@item6.name)

  end


end






