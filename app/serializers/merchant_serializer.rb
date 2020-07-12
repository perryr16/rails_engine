class MerchantSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name

  attribute :revenue do |object|
    object.attributes["revenue"]
  end

  attribute :items_sold do |object|
    object.attributes["items_sold"]
  end

end
