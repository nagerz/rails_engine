FactoryBot.define do
  factory :transaction do
    association :invoice, factory: :invoice
    credit_card_number { rand(4000000000000000..6000000000000000) }
    #credit_card_expiration_date { 2007-11-19 }
    result { "success" }
  end

  factory :failed_transaction, parent: :transaction do
    association :invoice, factory: :invoice
    result { "failed" }
  end
end
