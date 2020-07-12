FactoryBot.define do
  factory :item do
    sequence(:id) {|n| n }
    sequence(:name) {|n| "Item name #{n}" }
    sequence(:description) {|n| "Item description #{n}" }
    sequence(:unit_price) {|n| n + 0.95 }
  end
end
