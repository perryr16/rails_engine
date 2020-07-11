
FactoryBot.define do
  factory :transaction do
    sequence(:id) {|n| n }
    sequence(:credit_card_number, (1000000000000000..9999999999999999).cycle) { |n| 1 + n }
    # credit_card_number {(1000000000000000..9999999999999999).to_a.sample }
    sequence(:credit_card_expiration_date) {|n| n }
    result { ["success", "failed"].sample }
  end
end
