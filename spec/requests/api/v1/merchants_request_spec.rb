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
    it "sends the top merchants ranked by total revenue" do
      customer = create(:customer)
      #item = create(:item)

      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      merchant3 = create(:merchant)
      merchant4 = create(:merchant)

      invoice1 = create(:invoice, customer: customer, merchant: merchant1)
      invoice2 = create(:invoice, customer: customer, merchant: merchant2)
      invoice3 = create(:invoice, customer: customer, merchant: merchant2)
      invoice4 = create(:invoice, customer: customer, merchant: merchant3)
      invoice5 = create(:invoice, customer: customer, merchant: merchant4)

      invoice_item1 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 5)
      invoice_item2 = create(:invoice_item, invoice: invoice1, quantity: 1, unit_price: 4)
      invoice_item3 = create(:invoice_item, invoice: invoice2, quantity: 2, unit_price: 3)
      invoice_item4 = create(:invoice_item, invoice: invoice3, quantity: 3, unit_price: 6)
      invoice_item5 = create(:invoice_item, invoice: invoice4, quantity: 1, unit_price: 2)
      invoice_item6 = create(:invoice_item, invoice: invoice5, quantity: 1, unit_price: 97)

      x = 3

      get "/api/v1/merchants/most_revenue?quantity=#{x}"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants.count).to eq(3)
      expect(merchants[0]["name"]).to eq(merchant4.name)
      expect(merchants[1]["name"]).to eq(merchant2.name)
      expect(merchants[2]["name"]).to eq(merchant1.name)
    end
  end


end
