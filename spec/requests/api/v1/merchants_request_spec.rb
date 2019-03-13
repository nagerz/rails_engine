require 'rails_helper'

describe "Merchants API" do
  context "Record Endpoints" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(3)
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["id"]).to eq(id)
    end

    it "can find one merchant by its id" do
      create_list(:merchant, 3)
      id = Merchant.second.id

      get "/api/v1/merchants/find?id=#{id}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["id"]).to eq(id)
    end

    it "can find one merchant by its name" do
      create_list(:merchant, 3)
      name = Merchant.second.name

      get "/api/v1/merchants/find?name=#{name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["name"]).to eq(name)
    end

    it "can find one merchant by its created time" do
      create(:merchant, created_at: "2012-03-27 14:53:59 UTC")
      create(:merchant, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Merchant.second.created_at

      get "/api/v1/merchants/find?created_at=#{created_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["created_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can find one merchant by its updated time" do
      create(:merchant, updated_at: "2012-03-27 14:53:59 UTC")
      create(:merchant, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Merchant.second.updated_at

      get "/api/v1/merchants/find?updated_at=#{updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    xit "can find one merchant case insensitive name" do
      create_list(:merchant, 3)
      name = Merchant.second.name
      upcased_name = name.upcase

      get "/api/v1/merchants/find?name=#{upcased_name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant["name"]).to eq(name)
    end

    it "can find all merchants by id" do
      create_list(:merchant, 3)
      id = Merchant.second.id

      get "/api/v1/merchants/find_all?id=#{id}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant.first["id"]).to eq(id)
      expect(merchant.class).to eq(Array)
    end

    it "can find all merchants by name" do
      create_list(:merchant, 3)
      name = Merchant.second.name
      create(:merchant, name: name)

      get "/api/v1/merchants/find_all?name=#{name}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant.count).to eq(2)
      expect(merchant.first["name"]).to eq(name)
      expect(merchant.second["name"]).to eq(name)
    end

    it "can find all merchants by created time" do
      create(:merchant, created_at: "2012-03-27 14:53:59 UTC")
      create(:merchant, created_at: "2012-04-27 14:53:59 UTC")
      create(:merchant, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Merchant.first.created_at

      get "/api/v1/merchants/find_all?created_at=#{created_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant.count).to eq(2)
      expect(merchant.first["created_at"]).to eq("2012-03-27T14:53:59.000Z")
      expect(merchant.second["created_at"]).to eq("2012-03-27T14:53:59.000Z")
    end

    it "can find all merchants by updated time" do
      create(:merchant, updated_at: "2012-04-27 14:53:59 UTC")
      create(:merchant, updated_at: "2012-05-27 14:53:59 UTC")
      create(:merchant, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Merchant.first.updated_at

      get "/api/v1/merchants/find_all?updated_at=#{updated_at}"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(merchant.count).to eq(2)
      expect(merchant.first["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
      expect(merchant.second["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can get one merchant at random" do
      create_list(:merchant, 3)
      id1 = Merchant.first.id
      id2 = Merchant.second.id
      id3 = Merchant.third.id
      ids = [id1, id2, id3]

      get "/api/v1/merchants/random"

      merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(ids).to include(merchant["id"])
    end
  end

  context "Relationship Endpoints" do
    it "sends a list of items associated with a merchant" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      id = merchant1.id
      create_list(:item, 5, merchant: merchant1)
      create_list(:item, 5, merchant: merchant2)

      get "/api/v1/merchants/#{id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items.count).to eq(5)
    end

    it "sends a list of invoices associated with a merchant" do
      merchant1 = create(:merchant)
      id = merchant1.id

      merchant2 = create(:merchant)
      customer = create(:customer)
      create_list(:invoice, 5, customer: customer, merchant: merchant1)
      create_list(:invoice, 5, customer: customer, merchant: merchant2)

      get "/api/v1/merchants/#{id}/invoices"

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items.count).to eq(5)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
      date_one = "2012-03-25 09:54:09 UTC"
      date_two = "2012-03-07 09:54:09 UTC"
      date_today = Date.today.to_s

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
      invoice5 = create(:invoice, customer: customer, merchant: @m4, updated_at: date_today)
      invoice6 = create(:invoice, customer: customer, merchant: @m5, updated_at: date_one)

      invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 5)
      invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 4)
      invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 3)
      invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 6)
      invoice_item5 = create(:invoice_item, invoice: invoice4, quantity: 6, unit_price: 1)
      invoice_item6 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 97)
      invoice_item7 = create(:invoice_item, invoice: invoice6, quantity: 100, unit_price: 1000)

      transaction1 = create(:transaction, invoice: invoice1, result: "success", updated_at: date_one)
      transaction2 = create(:transaction, invoice: invoice2, result: "success", updated_at: date_two)
      transaction3 = create(:transaction, invoice: invoice3, result: "success", updated_at: date_one)
      transaction4 = create(:transaction, invoice: invoice4, result: "success", updated_at: date_one)
      transaction5 = create(:transaction, invoice: invoice5, result: "success", updated_at: date_today)
      transaction6 = create(:transaction, invoice: invoice6, result: "failed", updated_at: date_one)
    end

    it "sends the top merchants ranked by total revenue" do
      x = 3

      get "/api/v1/merchants/most_revenue?quantity=#{x}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(3)
      expect(merchants[0]["name"]).to eq(@m4.name)
      expect(merchants[0]["total_revenue"]).to eq(97)
      expect(merchants[1]["name"]).to eq(@m2.name)
      expect(merchants[1]["total_revenue"]).to eq(24)
      expect(merchants[2]["name"]).to eq(@m1.name)
      expect(merchants[2]["total_revenue"]).to eq(9)
    end

    it "sends the top merchants ranked by total revenue (no quantity provided)" do
      get "/api/v1/merchants/most_revenue"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(4)
      expect(merchants[0]["name"]).to eq(@m4.name)
      expect(merchants[0]["total_revenue"]).to eq(97)
      expect(merchants[1]["name"]).to eq(@m2.name)
      expect(merchants[1]["total_revenue"]).to eq(24)
      expect(merchants[2]["name"]).to eq(@m1.name)
      expect(merchants[2]["total_revenue"]).to eq(9)
      expect(merchants[3]["name"]).to eq(@m3.name)
      expect(merchants[3]["total_revenue"]).to eq(6)
    end

    it "sends the top merchants ranked by items sold" do
      x = 3

      get "/api/v1/merchants/most_items?quantity=#{x}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(3)
      expect(merchants[0]["name"]).to eq(@m3.name)
      expect(merchants[0]["items_sold"]).to eq(6)
      expect(merchants[1]["name"]).to eq(@m2.name)
      expect(merchants[1]["items_sold"]).to eq(5)
      expect(merchants[2]["name"]).to eq(@m1.name)
      expect(merchants[2]["items_sold"]).to eq(2)
    end

    it "sends the top merchants ranked by items sold (no quantity provided)" do
      get "/api/v1/merchants/most_items"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(4)
      expect(merchants[0]["name"]).to eq(@m3.name)
      expect(merchants[0]["items_sold"]).to eq(6)
      expect(merchants[1]["name"]).to eq(@m2.name)
      expect(merchants[1]["items_sold"]).to eq(5)
      expect(merchants[2]["name"]).to eq(@m1.name)
      expect(merchants[2]["items_sold"]).to eq(2)
      expect(merchants[3]["name"]).to eq(@m4.name)
      expect(merchants[3]["items_sold"]).to eq(1)
    end

    it "sends the total revenue for a date" do
      date_one = "2012-03-25"

      get "/api/v1/merchants/revenue?date=#{date_one}"

      expect(response).to be_successful

      revenue = JSON.parse(response.body)

      expect(revenue).to eq(33)
    end

    it "sends the total revenue for a date (no date provided)" do
      date_today = Date.today.to_s

      get "/api/v1/merchants/revenue?date=#{date_today}"

      expect(response).to be_successful

      revenue = JSON.parse(response.body)

      expect(revenue).to eq(97)
    end
  end


end
