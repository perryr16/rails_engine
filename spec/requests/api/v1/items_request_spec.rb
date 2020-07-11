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

    # original_body = {
    #   name: 'Item Autem Eligendi',
    #   description:'Aliquam dolores dolore voluptas nesciunt non praesentium. Eum nihil repellendus modi. Aut in expedita nesciunt. Ut aliquam dicta omnis voluptas.',
    #   unit_price: '29949',
    #   merchant_id: '3',
    # }
    # conn("/api/v1/items/").patch do |request|
    #   request.body = original_body
    # end
  end


end





# end

# describe 'Merchants' do
# it 'can get a merchant' do
#   response = conn('/api/v1/merchants/42').get

#   expected_attributes = {
#     name: 'Glover Inc',
#   }

#   json = JSON.parse(response.body, symbolize_names: true)

#   expect(json[:data][:id]).to eq('42')

#   expected_attributes.each do |attribute, value|
#     expect(json[:data][:attributes][attribute]).to eq(value)
#   end
# end

# it 'can get all merchants' do
#   response = conn('/api/v1/merchants').get
#   json = JSON.parse(response.body, symbolize_names: true)

#   expect(json[:data].length).to eq(100)
#   json[:data].each do |merchant|
#     expect(merchant[:type]).to eq("merchant")
#     expect(merchant[:attributes]).to have_key(:name)
#   end
# end

# it 'can create and delete a merchant' do
#   name = "Dingle Hoppers"

#   body = {
#     name: name
#   }

#   # Create a merchant
#   response = conn('/api/v1/merchants').post do |request|
#     request.body = body
#   end

#   json = JSON.parse(response.body, symbolize_names: true)

#   new_merchant = json[:data]
#   expect(new_merchant[:attributes][:name]).to eq(name)

#   # Delete a merchant
#   delete_response = conn("/api/v1/merchants/#{new_merchant[:id]}").delete

#   json = JSON.parse(response.body, symbolize_names: true)

#   deleted_merchant = json[:data]
#   expect(deleted_merchant[:attributes][:name]).to eq(name)
# end

# it 'can update a merchant' do
#   name = "Dingle Hoppers"

#   body = {
#     name: name,
#   }

#   response = conn('/api/v1/merchants/99').patch do |request|
#     request.body = body
#   end

#   json = JSON.parse(response.body, symbolize_names: true)
#   item = json[:data]
#   expect(item[:attributes][:name]).to eq(name)

#   original_body = {
#     name: 'Fahey-Stiedemann',
#   }
#   conn("/api/v1/merchants/99").patch do |request|
#     request.body = original_body
#   end
# end
# end
# end

# describe 'Relationships' do
# it 'can get items for a merchant' do
# response = conn('/api/v1/merchants/99/items').get
# json = JSON.parse(response.body, symbolize_names: true)
# expected_ids =
# [
#   2397, 2398, 2399, 2400, 2401, 2402, 2403, 2404, 2405, 2406,
#   2407, 2408, 2409, 2410, 2411, 2412, 2413, 2414, 2415, 2416,
#   2417, 2418, 2419, 2420, 2421, 2422, 2423, 2424, 2425, 2426,
#   2427, 2428, 2429, 2430, 2431, 2432, 2433, 2434, 2435, 2436,
#   2437, 2438
# ]
# item_ids = json[:data].map do |item|
#   item[:id].to_i
# end
# expect(item_ids.sort).to eq(expected_ids)
# end

# it 'can get merchant for an item' do
# response = conn('/api/v1/items/209/merchant').get
# json = JSON.parse(response.body, symbolize_names: true)
# expected_id = '11'

# expect(json[:data][:id]).to eq(expected_id)
# end
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