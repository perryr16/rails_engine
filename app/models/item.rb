class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  def self.find_all(params)
    where('lower(name) like ?', "%#{params[:name].downcase}%")
  end

  def self.find_one(params)
    find_all(params).first
  end
end
