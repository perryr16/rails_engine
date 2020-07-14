class Api::V1::Merchants::RevenueController < ApplicationController

  def index 
    # render json: MerchantSerializer.new(Merchant.most_revenue_between_dates(params))
    render json: RevenueSerializer.new(Merchant.most_revenue_between_dates(params))
  end

  def show 
     render json: RevenueSerializer.new(Merchant.individual_revenue(params))
  end
  
end