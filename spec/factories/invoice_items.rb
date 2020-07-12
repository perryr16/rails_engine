FactoryBot.define do
  factory :invoice_item do
    sequence(:id) {|n| n }
    sequence(:quantity) {|n| n }
    sequence(:unit_price) {|n| n + 0.75 }
  end
end