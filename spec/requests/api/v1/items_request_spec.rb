require 'rails_helper'
require 'rake'

describe "Items API" do

  before :each do 
    FactoryBot.reload

    @merchant1 = create(:merchant, id: 1)
    @merchant2 = create(:merchant, id: 2)
    
    10.times do 
      create(:item, merchant: @merchant2)
      create(:item, merchant: @merchant1)
    end

  end

  it "Returns all items" do

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].length).to eq(20)
    items[:data].each do |item|
      expect(item[:type]).to eq("item")
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes]).to have_key(:merchant_id)
    end
    
    expect(items[:data].count).to eq(20)
    expect(items[:data].first[:attributes][:name]).to eq('Item name 1')
  end

  it "can get an item" do 
  
    get '/api/v1/items/10'

    expected_attributes = {
    name: 'Item name 10',
    description: 'Item description 10',
    unit_price: 10.95,
    merchant_id: 1
    }
   
    item = JSON.parse(response.body, symbolize_names: true)
    expect(item[:data][:id]).to eq('10')

    expected_attributes.each do |attribute, value|
      expect(item[:data][:attributes][attribute]).to eq(value)
    end
  end

  it 'can create and delete an item' do
    merchant = create(:merchant, id: 43)

    name = "Shiny Itemy Item"
    description = "It does a lot of things real good"
    unit_price = 5011.96
    merchant_id = 43

    body = {
      name: name,
      description: description,
      unit_price: unit_price,
      merchant_id: merchant_id
    }

    # Create a item
    post '/api/v1/items', params: body

    json = JSON.parse(response.body, symbolize_names: true)

    new_item = json[:data]
    expect(new_item[:attributes][:name]).to eq(name)
    expect(new_item[:attributes][:description]).to eq(description)
    expect(new_item[:attributes][:unit_price]).to eq(unit_price)
    expect(new_item[:attributes][:merchant_id]).to eq(merchant_id)

    # Delete a item
    delete "/api/v1/items/#{new_item[:id]}"

    json = JSON.parse(response.body, symbolize_names: true)

    deleted_item = json[:data]
    expect(deleted_item[:attributes][:name]).to eq(name)
    expect(deleted_item[:attributes][:description]).to eq(description)
    expect(deleted_item[:attributes][:unit_price]).to eq(unit_price)
    expect(deleted_item[:attributes][:merchant_id]).to eq(merchant_id)
  end


  it 'can update an item' do
    merchant = create(:merchant, id: 43)
    item = create(:item, id: 75, merchant: merchant)

    name = "Shiny Itemy Item"
    description = "It does a lot of things real good"
    unit_price = 5011
    merchant_id = 43

    body = {
      name: name,
      description: description,
      unit_price: unit_price,
      merchant_id: merchant_id
    }

    patch '/api/v1/items/75', params: body


    json = JSON.parse(response.body, symbolize_names: true)
    item = json[:data]

    expect(item[:attributes][:name]).to eq(name)
    expect(item[:attributes][:description]).to eq(description)
    expect(item[:attributes][:unit_price]).to eq(unit_price)
    expect(item[:attributes][:merchant_id]).to eq(merchant_id)

  end

end
