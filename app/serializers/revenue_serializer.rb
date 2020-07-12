class RevenueSerializer
  include FastJsonapi::ObjectSerializer
  attributes 

  attribute :revenue do |object|
    object.attributes["revenue"].round(2) if object.attributes["revenue"]
  end

end
