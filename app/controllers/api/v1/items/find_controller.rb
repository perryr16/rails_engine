class Api::V1::Items::FindController < ApplicationController

  def index 
    render json: ItemSerializer.new(Item.find_all(params))
  end

  def show 
    render json: ItemSerializer.new(Item.find_one(params))
  end

  
end