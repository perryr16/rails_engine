class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  def self.find_all(params)
    where(sql_injection(params))
  end

  def self.find_one(params)
    find_all(params).first
  end

  def self.sql_injection(params)
    attributes = Item.first.attributes if Item.first
    search_terms = params.permit(attributes.keys).to_h
    injection = search_terms.map do |k,v|
      "lower(#{k}) LIKE '%#{v.downcase}%'"
    end
    injection.join(" OR ")
  end
end
