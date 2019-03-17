require 'rails_helper'

RSpec.describe ItemBestDay, type: :model do
  before :each do
    @date1 = "2012-03-25".to_date
    @date2 = "2012-03-07".to_date
    @date3 = "2012-03-08".to_date
    @date4 = "2012-03-09".to_date

    customer1 = create(:customer)
    customer2 = create(:customer)
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    @item1 = create(:item, merchant: merchant1)
    @item2 = create(:item, merchant: merchant1)
    @item3 = create(:item, merchant: merchant2)
    @item4 = create(:item, merchant: merchant2)

    invoice1 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date1)
    invoice2 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date2)
    invoice3 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date1)
    invoice4 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date2)
    invoice5 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)
    invoice6 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)
    invoice7 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)
    invoice8 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)

    invoice10 = create(:invoice, customer: customer2, merchant: merchant1, created_at: @date3)
    invoice11 = create(:invoice, customer: customer2, merchant: merchant1, created_at: @date4)

    invoice12 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: @date3)

    invoice_item1 = create(:invoice_item, item: @item1, invoice: invoice1, quantity: 1, unit_price: 100)
    invoice_item2 = create(:invoice_item, item: @item1, invoice: invoice2, quantity: 2, unit_price: 200)
    invoice_item3 = create(:invoice_item, item: @item2, invoice: invoice3, quantity: 3, unit_price: 300)
    invoice_item4 = create(:invoice_item, item: @item2, invoice: invoice4, quantity: 4, unit_price: 400)
    invoice_item5 = create(:invoice_item, item: @item3, invoice: invoice5, quantity: 5, unit_price: 500)
    invoice_item6 = create(:invoice_item, item: @item3, invoice: invoice6, quantity: 6, unit_price: 600)
    invoice_item7 = create(:invoice_item, item: @item4, invoice: invoice7, quantity: 7, unit_price: 700)
    invoice_item8 = create(:invoice_item, item: @item4, invoice: invoice8, quantity: 8, unit_price: 800)
    invoice_item9 = create(:invoice_item, item: @item1, invoice: invoice1, quantity: 1, unit_price: 100)
    invoice_item10 = create(:invoice_item, item: @item1, invoice: invoice10, quantity: 3, unit_price: 400)
    invoice_item11 = create(:invoice_item, item: @item1, invoice: invoice11, quantity: 3, unit_price: 400)

    invoice_item12 = create(:invoice_item, item: @item2, invoice: invoice12, quantity: 100, unit_price: 10000)

    transaction1 = create(:transaction, invoice: invoice1, result: "success")
    transaction2 = create(:transaction, invoice: invoice2, result: "success")
    transaction3 = create(:transaction, invoice: invoice3, result: "success")
    transaction4 = create(:transaction, invoice: invoice4, result: "success")
    transaction5 = create(:transaction, invoice: invoice5, result: "success")
    transaction6 = create(:transaction, invoice: invoice6, result: "success")
    transaction7 = create(:transaction, invoice: invoice7, result: "success")
    transaction8 = create(:transaction, invoice: invoice8, result: "success")
    transaction10 = create(:transaction, invoice: invoice10, result: "success")
    transaction11 = create(:transaction, invoice: invoice11, result: "success")

    transaction12 = create(:transaction, invoice: invoice12, result: "failed")
  end

  it ".initialize" do

    id1 = @item1.id
    id2 = @item2.id
    d2 = @date2.to_date
    d4 = @date4.to_date

    day = ItemBestDay.new(id1)
    expect(day.best_day).to eq(d4)
    expect(day.id).to eq(nil)
  end
end
