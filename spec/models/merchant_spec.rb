require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'class methods' do
    before :each do
      date_one = "2012-03-25 09:54:09 UTC"
      date_two = "2012-03-07 09:54:09 UTC"

      customer = create(:customer)

      @m1 = create(:merchant)
      @m2 = create(:merchant)
      @m3 = create(:merchant)
      @m4 = create(:merchant)
      @m5 = create(:merchant)

      invoice1 = create(:invoice, customer: customer, merchant: @m1, updated_at: date_one)
      invoice2 = create(:invoice, customer: customer, merchant: @m2, updated_at: date_two)
      invoice3 = create(:invoice, customer: customer, merchant: @m2, updated_at: date_one)
      invoice4 = create(:invoice, customer: customer, merchant: @m3, updated_at: date_one)
      invoice5 = create(:invoice, customer: customer, merchant: @m4, updated_at: date_two)
      invoice6 = create(:invoice, customer: customer, merchant: @m5, updated_at: date_one)
      invoice7 = create(:invoice, customer: customer, merchant: @m2, updated_at: date_one)

      invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 500)
      invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 400)
      invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 300)
      invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 600)
      invoice_item5 = create(:invoice_item, invoice: invoice4, quantity: 6, unit_price: 100)
      invoice_item6 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 9700)
      invoice_item7 = create(:invoice_item, invoice: invoice6, quantity: 100, unit_price: 100000)
      invoice_item8 = create(:invoice_item, invoice: invoice7, quantity: 100, unit_price: 100000)

      transaction1 = create(:transaction, invoice: invoice1, result: "success")
      transaction2 = create(:transaction, invoice: invoice2, result: "success")
      transaction3 = create(:transaction, invoice: invoice3, result: "success")
      transaction4 = create(:transaction, invoice: invoice4, result: "success")
      transaction5 = create(:transaction, invoice: invoice5, result: "success")
      transaction6 = create(:transaction, invoice: invoice6, result: "failed")
      transaction7 = create(:transaction, invoice: invoice7, result: "failed")
    end

    it ".merchants_sorted_by_revenue" do
      expect(Merchant.merchants_sorted_by_revenue).to eq([@m4, @m2, @m1, @m3])
    end

    it ".merchants_sorted_by_items_sold" do
      expect(Merchant.merchants_sorted_by_items).to eq([@m3, @m2, @m1, @m4])
    end

    it ".top_merchants_by_revenue()" do
      expect(Merchant.top_merchants_by_revenue(3)).to eq([@m4, @m2, @m1])
    end

    it ".top_merchants_by_items_sold()" do
      expect(Merchant.top_merchants_by_items(3)).to eq([@m3, @m2, @m1])
    end

    it ".merchants_total_revenue_date()" do
      date_one = "2012-03-25"

      expect(Merchant.merchants_total_revenue_date(date_one)).to eq(3300)
    end

    it ".merchant_total_revenue" do
      id = @m2.id

      expect(Merchant.merchant_total_revenue(id)).to eq(2400)
    end

    it ".merchant_total_revenue(with date)" do
      id = @m2.id
      date = "2012-03-25"

      expect(Merchant.merchant_total_revenue(id, date)).to eq(1800)
    end
  end

end
