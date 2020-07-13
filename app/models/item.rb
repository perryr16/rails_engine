class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  def self.find_all(params)
    # where('lower(name) like ?', "%#{params[:name].downcase}%")
    if params[:name] && params[:description]
      where("lower(name) LIKE '%#{params[:name].downcase}%' OR lower(description) LIKE '%#{params[:description].downcase}%'")
    elsif params[:name]
      where("lower(name) LIKE '%#{params[:name].downcase}%'")
    elsif params[:description]
      where("lower(description) LIKE '%#{params[:description].downcase}%'")
    end

  end

  def self.find_one(params)
    find_all(params).first
  end

  def params_match_attributes(params)
    Item.first.attributes.keys
  end
end
