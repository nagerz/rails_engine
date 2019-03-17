require 'rails_helper'

RSpec.describe MerchantRevenue, type: :model do
  before :each do
    date_one = "2012-03-25 09:54:09 UTC"
    date_two = "2012-03-07 09:54:09 UTC"
    date_three = "2012-03-10 09:54:09 UTC"

    @c1 = create(:customer)
    @c2 = create(:customer)

    @m1 = create(:merchant)
    @m2 = create(:merchant)
    @m3 = create(:merchant)
    @m4 = create(:merchant)
    @m5 = create(:merchant)

    invoice1 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)
    invoice2 = create(:invoice, customer: @c1, merchant: @m2, updated_at: date_two)
    invoice3 = create(:invoice, customer: @c1, merchant: @m2, updated_at: date_one)
    invoice4 = create(:invoice, customer: @c1, merchant: @m3, updated_at: date_one)
    invoice5 = create(:invoice, customer: @c1, merchant: @m4, updated_at: date_two)
    invoice6 = create(:invoice, customer: @c1, merchant: @m5, updated_at: date_one)
    invoice7 = create(:invoice, customer: @c1, merchant: @m2, updated_at: date_one)
    invoice8 = create(:invoice, customer: @c2, merchant: @m2, updated_at: date_three)

    invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 500)
    invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 400)
    invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 300)
    invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 600)
    invoice_item5 = create(:invoice_item, invoice: invoice4, quantity: 7, unit_price: 100)
    invoice_item6 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 9700)
    invoice_item7 = create(:invoice_item, invoice: invoice6, quantity: 100, unit_price: 100000)
    invoice_item8 = create(:invoice_item, invoice: invoice7, quantity: 100, unit_price: 100000)
    invoice_item9 = create(:invoice_item, invoice: invoice8, quantity: 1, unit_price: 755)

    transaction1 = create(:transaction, invoice: invoice1, result: "success")
    transaction2 = create(:transaction, invoice: invoice2, result: "success")
    transaction3 = create(:transaction, invoice: invoice3, result: "success")
    transaction4 = create(:transaction, invoice: invoice4, result: "success")
    transaction5 = create(:transaction, invoice: invoice5, result: "success")
    transaction6 = create(:transaction, invoice: invoice6, result: "failed")
    transaction7 = create(:transaction, invoice: invoice7, result: "failed")
    transaction8 = create(:transaction, invoice: invoice8, result: "success")
  end

  it ".initialize" do
    id = @m2.id
    date = "2012-03-25"

    total_revenue = MerchantRevenue.new(date, id)
    expect(total_revenue.revenue).to eq(1800)
    expect(total_revenue.id).to eq(nil)

    total_revenue_date = MerchantRevenue.new(date)
    expect(total_revenue_date.revenue).to eq(3400)
    expect(total_revenue_date.id).to eq(nil)
  end

end
