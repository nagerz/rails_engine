require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices)}
    it { should have_many(:transactions).through(:invoices)}
  end

  describe 'class methods' do
    before :each do
      date_one = "2012-03-25 09:54:09 UTC"

      @c1 = create(:customer)
      @c2 = create(:customer)
      @c3 = create(:customer)

      @m1 = create(:merchant)
      @m2 = create(:merchant)

      invoice1 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)
      invoice2 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)

      invoice3 = create(:invoice, customer: @c2, merchant: @m1, updated_at: date_one)
      invoice4 = create(:invoice, customer: @c2, merchant: @m1, updated_at: date_one)
      invoice5 = create(:invoice, customer: @c2, merchant: @m1, updated_at: date_one)

      invoice6 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)
      invoice9 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)
      invoice10 = create(:invoice, customer: @c3, merchant: @m1, updated_at: date_one)

      invoice7 = create(:invoice, customer: @c1, merchant: @m2, updated_at: date_one)
      invoice8 = create(:invoice, customer: @c1, merchant: @m2, updated_at: date_one)


      invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 500)
      invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 400)
      invoice_item3 = create(:invoice_item, invoice: invoice1, quantity: 2, unit_price: 300)
      invoice_item4 = create(:invoice_item, invoice: invoice1, quantity: 30, unit_price: 600)

      invoice_item5 = create(:invoice_item, invoice: invoice2, quantity: 7, unit_price: 100)
      invoice_item6 = create(:invoice_item, invoice: invoice2, quantity: 1, unit_price: 970)
      invoice_item7 = create(:invoice_item, invoice: invoice3, quantity: 10, unit_price: 555)
      invoice_item8 = create(:invoice_item, invoice: invoice4, quantity: 10, unit_price: 150)

      invoice_item9 = create(:invoice_item, invoice: invoice5, quantity: 10, unit_price: 150)

      transaction1 = create(:transaction, invoice: invoice1, result: "success")
      transaction2 = create(:transaction, invoice: invoice2, result: "success")
      transaction3 = create(:transaction, invoice: invoice3, result: "success")
      transaction4 = create(:transaction, invoice: invoice4, result: "success")
      transaction5 = create(:transaction, invoice: invoice5, result: "success")
      transaction6 = create(:transaction, invoice: invoice6, result: "failed")
      transaction7 = create(:transaction, invoice: invoice7, result: "success")
      transaction8 = create(:transaction, invoice: invoice8, result: "success")
      transaction9 = create(:transaction, invoice: invoice9, result: "failed")
      transaction23 = create(:transaction, invoice: invoice3, result: "failed")
    end

    it ".merchant_favorite_customer()" do
      mid1 = @m1.id
      mid2 = @m2.id
      cid1 = @c1.id
      cid2 = @c2.id

      expect(Customer.merchant_favorite_customer(mid1)).to eq(@c2)
      expect(Customer.merchant_favorite_customer(mid1).id).to eq(cid2)
      expect(Customer.merchant_favorite_customer(mid1).transaction_count).to eq(3)

      expect(Customer.merchant_favorite_customer(mid2)).to eq(@c1)
      expect(Customer.merchant_favorite_customer(mid2).id).to eq(cid1)
      expect(Customer.merchant_favorite_customer(mid2).transaction_count).to eq(2)
    end

    xit ".merchant_pending_invoice_customers()" do
      mid1 = @m1.id
      mid2 = @m2.id

      expect(Customer.merchant_pending_invoice_customers(mid1).size).to eq(2)
      expect(Customer.merchant_pending_invoice_customers(mid1).first).to eq(@c1)
      expect(Customer.merchant_pending_invoice_customers(mid1).second).to eq(@c3)

      expect(Customer.merchant_pending_invoice_customers(mid2)).to eq(nil)
    end
  end
end
