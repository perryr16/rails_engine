FactoryBot.define do
  factory :invoice do
    sequence(:id) { |n| n } 
    status { "shipped" }
  end
end
