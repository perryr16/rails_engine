class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy

  def self.find_all(params)

    where(sql_injection(params))
    # where("updated_at = '#{params[:updated_at]}'")
    # where("created_at > '2010-01-01'" 
  end

  def self.find_one(params)
    find_all(params).first
  end

  def self.sql_injection(params)
    attributes = Item.first.attributes if Item.first
    search_terms = params.permit(attributes.keys).to_h
    injection = search_terms.map do |k,v|
      param_generator(k, v)
      # "lower(#{key}) LIKE '%#{value.downcase}%'"
    end
    injection.join(" AND ")
  end

  def self.param_generator(key, value)
    if key.include?('ated_at')
      value = value.to_datetime
      "#{key} >= '#{value}' AND #{key} < '#{value+1}'"
    else 
      "lower(#{key}) LIKE '%#{value.downcase}%'"
    end
  end

end
