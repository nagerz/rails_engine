FactoryBot.define do
  factory :merchant do
    sequence(:name) { |n| "Merchant_#{n}" }
  end
end
