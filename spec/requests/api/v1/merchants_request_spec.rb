require 'rails_helper'

describe "Merchants API" do

  before :each do 
    FactoryBot.reload

    # @merchant1 = create(:merchant, id: )
    # @merchant2 = create(:merchant, id: 2)
    
    # 10.times do 
    #   create(:item, merchant: @merchant2)
    #   create(:item, merchant: @merchant1)
    # end

  end

  it "Can get a merchant" do
    merchant1 = create(:merchant, id: 42, name: "Glover Inc")
    merchant2 = create(:merchant, id: 43, name: "Booter Inc")

    get '/api/v1/merchants/42'

    expected_attributes = {
      name: 'Glover Inc',
    }

    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data][:id]).to eq('42')

    expected_attributes.each do |attribute, value|
      expect(json[:data][:attributes][attribute]).to eq(value)
    end
  end

  it "Can get a merchant" do

    get '/api/v1/dog'

      binding.pry
    
  end

  it 'can get a merchant' do
    100.times do 
      create(:merchant)
    end

    get '/api/v1/merchants'
    json = JSON.parse(response.body, symbolize_names: true)

    expect(json[:data].length).to eq(100)
    json[:data].each do |merchant|
      expect(merchant[:type]).to eq("merchant")
      expect(merchant[:attributes]).to have_key(:name)
    end
  end

  it 'can create and delete a merchant' do
    name = "Dingle Hoppers"

    body = {
      name: name
    }

    # Create a merchant
    post '/api/v1/merchants', params: body

    json = JSON.parse(response.body, symbolize_names: true)

    new_merchant = json[:data]

    expect(new_merchant[:attributes][:name]).to eq(name)

    # Delete a merchant
    delete "/api/v1/merchants/#{new_merchant[:id]}"

    json = JSON.parse(response.body, symbolize_names: true)

    deleted_merchant = json[:data]
    expect(deleted_merchant[:attributes][:name]).to eq(name)
  end

  it 'can update a merchant' do
    create(:merchant, id: 98)
    create(:merchant, id: 99, name: 'dog')

    get '/api/v1/merchants/99'

    json = JSON.parse(response.body, symbolize_names: true)
    expect(json[:data][:attributes][:name]).to eq('dog')


    new_name = "Dingle Hoppers"

    body = {
      name: new_name,
    }

    patch'/api/v1/merchants/99', params: body

    json = JSON.parse(response.body, symbolize_names: true)
    merchant = json[:data]
    expect(merchant[:attributes][:name]).to eq(new_name)
  end


end
