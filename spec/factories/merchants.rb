FactoryBot.define do
  factory :merchant do
    # reset_sequence { 1 }
    sequence(:id) {|n| n }
    sequence(:name) {|n| "Merchant name #{n}" }
  end
end
