FactoryBot.define do
  factory :merchant do
    sequence(:id) {|n| n }
    sequence(:name) {|n| "Merchant name #{n}" }
  end
end
