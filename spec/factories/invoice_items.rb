FactoryBot.define do
  factory :invoice_item do
    association :item, factory: :item
    association :invoice, factory: :invoice
    sequence(:quantity) { |n| n*5 }
    sequence(:unit_price) { |n| n }

    status { "shipped" }

  end
end
