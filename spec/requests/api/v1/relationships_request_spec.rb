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
