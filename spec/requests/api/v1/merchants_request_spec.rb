require 'rails_helper'

describe "Merchants API" do
  context "Record Endpoints" do
    it "sends a list of merchants" do
      create_list(:merchant, 3)

      get '/api/v1/merchants'

      expect(response).to be_successful

      merchants = JSON.parse(response.body)["data"]

      expect(merchants.count).to eq(3)
    end

    it "can get one merchant by its id" do
      id = create(:merchant).id

      get "/api/v1/merchants/#{id}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(id)
    end

    it "can find one merchant by its id" do
      create_list(:merchant, 3)
      id = Merchant.second.id

      get "/api/v1/merchants/find?id=#{id}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(id)
    end

    it "can find one merchant by its name" do
      create_list(:merchant, 3)
      name = Merchant.second.name

      get "/api/v1/merchants/find?name=#{name}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["attributes"]["name"]).to eq(name)
    end

    it "can find one merchant by its created time" do
      create(:merchant, created_at: "2012-03-27 14:53:59 UTC")
      create(:merchant, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Merchant.second.created_at
      id = Merchant.second.id

      get "/api/v1/merchants/find?created_at=#{created_at}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(id)
    end

    it "can find one merchant by its updated time" do
      create(:merchant, updated_at: "2012-03-27 14:53:59 UTC")
      create(:merchant, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Merchant.second.updated_at
      id = Merchant.second.id

      get "/api/v1/merchants/find?updated_at=#{updated_at}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["id"].to_i).to eq(id)
    end

    it "can find one merchant case insensitive name" do
      create_list(:merchant, 3)
      name = Merchant.second.name
      upcased_name = name.upcase

      get "/api/v1/merchants/find?name=#{upcased_name}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant["attributes"]["name"]).to eq(name)
    end

    it "can find all merchants by id" do
      create_list(:merchant, 3)
      id = Merchant.second.id

      get "/api/v1/merchants/find_all?id=#{id}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant.first["id"].to_i).to eq(id)
      expect(merchant.class).to eq(Array)
    end

    it "can find all merchants by name" do
      create_list(:merchant, 3)
      name = Merchant.second.name
      create(:merchant, name: name)

      get "/api/v1/merchants/find_all?name=#{name}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant.count).to eq(2)
      expect(merchant.first["attributes"]["name"]).to eq(name)
      expect(merchant.second["attributes"]["name"]).to eq(name)
    end

    it "can find all merchants by created time" do
      create(:merchant, created_at: "2012-03-27 14:53:59 UTC")
      create(:merchant, created_at: "2012-04-27 14:53:59 UTC")
      create(:merchant, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Merchant.first.created_at
      id1 = Merchant.first.id
      id3 = Merchant.third.id

      get "/api/v1/merchants/find_all?created_at=#{created_at}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant.count).to eq(2)
      expect(merchant.first["id"].to_i).to eq(id1)
      expect(merchant.second["id"].to_i).to eq(id3)
    end

    it "can find all merchants by updated time" do
      create(:merchant, updated_at: "2012-04-27 14:53:59 UTC")
      create(:merchant, updated_at: "2012-05-27 14:53:59 UTC")
      create(:merchant, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Merchant.first.updated_at
      id1 = Merchant.first.id
      id3 = Merchant.third.id

      get "/api/v1/merchants/find_all?updated_at=#{updated_at}"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(merchant.count).to eq(2)
      expect(merchant.first["id"].to_i).to eq(id1)
      expect(merchant.second["id"].to_i).to eq(id3)
    end

    it "can get one merchant at random" do
      create_list(:merchant, 3)
      id1 = Merchant.first.id
      id2 = Merchant.second.id
      id3 = Merchant.third.id
      ids = [id1, id2, id3]

      get "/api/v1/merchants/random"

      merchant = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(ids).to include(merchant["id"].to_i)
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

      items = JSON.parse(response.body)["data"]

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

      items = JSON.parse(response.body)["data"]

      expect(items.count).to eq(5)
    end
  end

  context "Business Intelligence Endpoints" do
    context "All Merchants" do
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

        invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 500)
        invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 400)
        invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 300)
        invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 600)
        invoice_item5 = create(:invoice_item, invoice: invoice4, quantity: 6, unit_price: 100)
        invoice_item6 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 9700)
        invoice_item7 = create(:invoice_item, invoice: invoice6, quantity: 100, unit_price: 100000)

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

        merchants = JSON.parse(response.body)["data"]

        expect(merchants.count).to eq(3)
        expect(merchants[0]["attributes"]["name"]).to eq(@m4.name)
        expect(merchants[1]["attributes"]["name"]).to eq(@m2.name)
        expect(merchants[2]["attributes"]["name"]).to eq(@m1.name)
      end

      it "sends the top merchants ranked by total revenue (no quantity provided)" do
        get "/api/v1/merchants/most_revenue"

        expect(response).to be_successful

        merchants = JSON.parse(response.body)["data"]

        expect(merchants.count).to eq(4)
        expect(merchants[0]["attributes"]["name"]).to eq(@m4.name)
        expect(merchants[1]["attributes"]["name"]).to eq(@m2.name)
        expect(merchants[2]["attributes"]["name"]).to eq(@m1.name)
        expect(merchants[3]["attributes"]["name"]).to eq(@m3.name)
      end

      it "sends the top merchants ranked by items sold" do
        x = 3

        get "/api/v1/merchants/most_items?quantity=#{x}"

        expect(response).to be_successful

        merchants = JSON.parse(response.body)["data"]

        expect(merchants.count).to eq(3)
        expect(merchants[0]["attributes"]["name"]).to eq(@m3.name)
        expect(merchants[1]["attributes"]["name"]).to eq(@m2.name)
        expect(merchants[2]["attributes"]["name"]).to eq(@m1.name)
      end

      it "sends the top merchants ranked by items sold (no quantity provided)" do
        get "/api/v1/merchants/most_items"

        expect(response).to be_successful

        merchants = JSON.parse(response.body)["data"]

        expect(merchants.count).to eq(4)
        expect(merchants[0]["attributes"]["name"]).to eq(@m3.name)
        expect(merchants[1]["attributes"]["name"]).to eq(@m2.name)
        expect(merchants[2]["attributes"]["name"]).to eq(@m1.name)
        expect(merchants[3]["attributes"]["name"]).to eq(@m4.name)
      end

      it "sends the total revenue for a date" do
        date_one = "2012-03-25"

        get "/api/v1/merchants/revenue?date=#{date_one}"

        expect(response).to be_successful

        revenue = JSON.parse(response.body)["data"]["attributes"]["total_revenue"]

        expect(revenue).to eq("33.00")
      end

      it "sends the total revenue for a date (no date provided)" do
        date_today = Date.today.to_s

        get "/api/v1/merchants/revenue?date=#{date_today}"

        expect(response).to be_successful

        revenue = JSON.parse(response.body)["data"]["attributes"]["total_revenue"]

        expect(revenue).to eq("97.00")
      end
    end

    context "Single Merchant" do
      before :each do
        date_one = "2012-03-25 09:54:09 UTC"
        date_two = "2012-03-07 09:54:09 UTC"
        date_today = Date.today.to_s

        @c1 = create(:customer)
        @c2 = create(:customer)
        @c3 = create(:customer)
        @c4 = create(:customer)

        @m1 = create(:merchant)
        @m2 = create(:merchant)

        invoice1 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)
        #invoice with different customer
        invoice2 = create(:invoice, customer: @c2, merchant: @m1, updated_at: date_one)
        #invoice updated on different day
        invoice3 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_two)
        #invoice belonging to different merchant
        invoice4 = create(:invoice, customer: @c1, merchant: @m2, updated_at: date_one)
        #invoice with failed transaction
        invoice5 = create(:invoice, customer: @c1, merchant: @m1, updated_at: date_one)
        invoice6 = create(:invoice, customer: @c3, merchant: @m1, updated_at: date_one)
        invoice7 = create(:invoice, customer: @c4, merchant: @m1, updated_at: date_one)

        invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 200)
        invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 300)
        invoice_item3 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 500)
        invoice_item4 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 500)
        invoice_item5 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 600)

        invoice_item6 = create(:invoice_item, invoice: invoice4, quantity: 6, unit_price: 700)
        invoice_item7 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 9700)

        transaction1 = create(:transaction, invoice: invoice1, result: "success", updated_at: date_one)
        transaction2 = create(:transaction, invoice: invoice2, result: "success", updated_at: date_two)
        transaction3 = create(:transaction, invoice: invoice3, result: "success", updated_at: date_one)

        transaction4 = create(:transaction, invoice: invoice4, result: "success", updated_at: date_one)
        transaction5 = create(:transaction, invoice: invoice5, result: "failed", updated_at: date_today)
        transaction6 = create(:transaction, invoice: invoice6, result: "failed", updated_at: date_today)
      end

      it "sends the total revenue for a merchant across successful transactions" do
        id = @m1.id

        get "/api/v1/merchants/#{id}/revenue"

        expect(response).to be_successful

        revenue = JSON.parse(response.body)["data"]["attributes"]["revenue"]

        expect(revenue).to eq("38.00")
      end

      it "sends the total revenue for a merchant for a specific invoice date" do
        id = @m1.id
        date_one = "2012-03-25"

        get "/api/v1/merchants/#{id}/revenue?date=#{date_one}"

        expect(response).to be_successful

        revenue = JSON.parse(response.body)["data"]["attributes"]["revenue"]

        expect(revenue).to eq("20.00")
      end
      it "sends the customer who has conducted the most total number of successful transactions" do
        id = @m1.id
        cid = @c1.id

        get "/api/v1/merchants/#{id}/favorite_customer"

        expect(response).to be_successful

        customer = JSON.parse(response.body)["data"]

        expect(customer["attributes"]["id"].to_i).to eq(cid)
      end

      it "sends a collection of customers which have pending (unpaid) invoices" do
        mid = @m1.id
        c1id = @c1.id
        c3id = @c3.id
        c4id = @c4.id

        get "/api/v1/merchants/#{mid}/customers_with_pending_invoices"

        expect(response).to be_successful

        customers = JSON.parse(response.body)["data"]

        expect(customers.size).to eq(3)
        expect(customers.first["attributes"]["id"].to_i).to eq(c1id)
        expect(customers.second["attributes"]["id"].to_i).to eq(c3id)
        expect(customers.third["attributes"]["id"].to_i).to eq(c4id)
      end

    end
  end


end
