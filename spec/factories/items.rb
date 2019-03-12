FactoryBot.define do
  factory :item do
    association :merchant, factory: :merchant
    sequence(:name) { |n| "Item_#{n}" }
    sequence(:description) { |n| "Description_#{n}" }
    sequence(:unit_price) { |n| n }
  end
end
