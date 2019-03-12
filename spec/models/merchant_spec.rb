require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices)}
  end

  describe 'class methods' do
    before :each do
      customer = create(:customer)
      #item = create(:item)

      @m1 = create(:merchant)
      @m2 = create(:merchant)
      @m3 = create(:merchant)
      @m4 = create(:merchant)

      invoice1 = create(:invoice, customer: customer, merchant: @m1)
      invoice2 = create(:invoice, customer: customer, merchant: @m2)
      invoice3 = create(:invoice, customer: customer, merchant: @m2)
      invoice4 = create(:invoice, customer: customer, merchant: @m3)
      invoice5 = create(:invoice, customer: customer, merchant: @m4)

      invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 5)
      invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 4)
      invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 3)
      invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 6)
      invoice_item5 = create(:invoice_item, invoice: invoice4, quantity: 1, unit_price: 2)
      invoice_item6 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 97)
    end

    it ".merchants_sorted_by_revenue" do
      expect(Merchant.merchants_sorted_by_revenue).to eq([@m4, @m2, @m1, @m3])
    end

    it ".top_merchants_by_revenue()" do
      expect(Merchant.top_merchants_by_revenue(3)).to eq([@m4, @m2, @m1])
    end
  end

end
