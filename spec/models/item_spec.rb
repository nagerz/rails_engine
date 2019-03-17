require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items)}
  end

  context "Class Methods" do
    before :each do
      date_one = "2012-03-25 09:54:09 UTC"
      date_two = "2012-03-07 09:54:09 UTC"

      customer1 = create(:customer)
      customer2 = create(:customer)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      @item1 = create(:item, merchant: merchant1)
      @item2 = create(:item, merchant: merchant1)
      @item3 = create(:item, merchant: merchant2)
      @item4 = create(:item, merchant: merchant2)

      invoice1 = create(:invoice, customer: customer1, merchant: merchant1, updated_at: date_one)
      invoice2 = create(:invoice, customer: customer1, merchant: merchant1, updated_at: date_one)
      invoice3 = create(:invoice, customer: customer1, merchant: merchant1, updated_at: date_one)
      invoice4 = create(:invoice, customer: customer1, merchant: merchant1, updated_at: date_one)
      invoice5 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: date_one)
      invoice6 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: date_one)
      invoice7 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: date_one)
      invoice8 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: date_one)

      invoice10 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: date_one)

      invoice_item1 = create(:invoice_item, item: @item1, invoice: invoice1, quantity: 1, unit_price: 100)
      invoice_item2 = create(:invoice_item, item: @item1, invoice: invoice2, quantity: 2, unit_price: 200)
      invoice_item3 = create(:invoice_item, item: @item2, invoice: invoice3, quantity: 3, unit_price: 300)
      invoice_item4 = create(:invoice_item, item: @item2, invoice: invoice4, quantity: 4, unit_price: 400)
      invoice_item5 = create(:invoice_item, item: @item3, invoice: invoice5, quantity: 5, unit_price: 500)
      invoice_item6 = create(:invoice_item, item: @item3, invoice: invoice6, quantity: 6, unit_price: 600)
      invoice_item7 = create(:invoice_item, item: @item4, invoice: invoice7, quantity: 7, unit_price: 700)
      invoice_item8 = create(:invoice_item, item: @item4, invoice: invoice8, quantity: 8, unit_price: 800)
      invoice_item9 = create(:invoice_item, item: @item1, invoice: invoice1, quantity: 5, unit_price: 500)

      invoice_item10 = create(:invoice_item, item: @item2, invoice: invoice10, quantity: 100, unit_price: 10000)

      transaction1 = create(:transaction, invoice: invoice1, result: "success")
      transaction2 = create(:transaction, invoice: invoice2, result: "success")
      transaction3 = create(:transaction, invoice: invoice3, result: "success")
      transaction4 = create(:transaction, invoice: invoice4, result: "success")
      transaction5 = create(:transaction, invoice: invoice5, result: "success")
      transaction6 = create(:transaction, invoice: invoice6, result: "success")
      transaction7 = create(:transaction, invoice: invoice7, result: "success")
      transaction8 = create(:transaction, invoice: invoice8, result: "success")

      transaction10 = create(:transaction, invoice: invoice10, result: "failed")
    end

    it ".items_sorted_by_revenue" do
      expect(Item.items_sorted_by_revenue).to eq([@item4, @item3, @item1, @item2])
    end

    it ".items_sorted_by_volume" do
      expect(Item.items_sorted_by_volume).to eq([@item4, @item3, @item1, @item2])
    end

    it ".top_items_by_revenue()" do
      expect(Item.top_items_by_revenue("3")).to eq([@item4, @item3, @item1])
    end

    it ".top_items_by_volume()" do
      expect(Item.top_items_by_volume("3")).to eq([@item4, @item3, @item1])
    end
  end
end
