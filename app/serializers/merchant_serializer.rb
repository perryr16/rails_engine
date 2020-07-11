class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  # attribute :merchant_id do |object|
  #   object.merchant_id
  # end

end
