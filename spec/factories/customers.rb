FactoryBot.define do
  factory :customer do
    sequence(:first_name) { |n| "Customer_#{n}" }
    sequence(:last_name) { |n| "Lastname_#{n}" }
  end
end
