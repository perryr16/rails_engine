class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy

  def self.find_all(params)
    where('lower(name) like ?', "%#{params[:name].downcase}%")
  end

  def self.find_one(params)
    find_all(params).first
  end
  
end
