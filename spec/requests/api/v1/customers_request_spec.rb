require 'rails_helper'

describe "Customers API" do
  context "Record Endpoints" do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get '/api/v1/customers'

      expect(response).to be_successful

      customers = JSON.parse(response.body)

      expect(customers.count).to eq(3)
    end

    it "can get one customer by its id" do
      id = create(:customer).id

      get "/api/v1/customers/#{id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["id"]).to eq(id)
    end

    it "can find one customer by its id" do
      create_list(:customer, 3)
      id = Customer.second.id

      get "/api/v1/customers/find?id=#{id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["id"]).to eq(id)
    end

    it "can find one customer by its first name" do
      create_list(:customer, 3)
      name = Customer.second.first_name

      get "/api/v1/customers/find?first_name=#{name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["first_name"]).to eq(name)
    end

    it "can find one customer by its last name" do
      create_list(:customer, 3)
      name = Customer.second.last_name

      get "/api/v1/customers/find?last_name=#{name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["last_name"]).to eq(name)
    end

    it "can find one customer by its created time" do
      create(:customer, created_at: "2012-03-27 14:53:59 UTC")
      create(:customer, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Customer.second.created_at

      get "/api/v1/customers/find?created_at=#{created_at}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["created_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can find one customer by its updated time" do
      create(:customer, updated_at: "2012-03-27 14:53:59 UTC")
      create(:customer, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Customer.second.updated_at

      get "/api/v1/customers/find?updated_at=#{updated_at}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    xit "can find one customer case insensitive name" do
      create_list(:customer, 3)
      name = Customer.second.name
      upcased_name = name.upcase

      get "/api/v1/customers/find?name=#{upcased_name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer["name"]).to eq(name)
    end

    it "can find all customers by id" do
      create_list(:customer, 3)
      id = Customer.second.id

      get "/api/v1/customers/find_all?id=#{id}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer.first["id"]).to eq(id)
      expect(customer.class).to eq(Array)
    end

    it "can find all customers by first name" do
      create_list(:customer, 3)
      name = Customer.second.first_name
      create(:customer, first_name: name)

      get "/api/v1/customers/find_all?first_name=#{name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["first_name"]).to eq(name)
      expect(customer.second["first_name"]).to eq(name)
    end

    it "can find all customers by last name" do
      create_list(:customer, 3)
      name = Customer.second.last_name
      create(:customer, last_name: name)

      get "/api/v1/customers/find_all?last_name=#{name}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["last_name"]).to eq(name)
      expect(customer.second["last_name"]).to eq(name)
    end

    it "can find all customers by created time" do
      create(:customer, created_at: "2012-03-27 14:53:59 UTC")
      create(:customer, created_at: "2012-04-27 14:53:59 UTC")
      create(:customer, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Customer.first.created_at

      get "/api/v1/customers/find_all?created_at=#{created_at}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["created_at"]).to eq("2012-03-27T14:53:59.000Z")
      expect(customer.second["created_at"]).to eq("2012-03-27T14:53:59.000Z")
    end

    it "can find all customers by updated time" do
      create(:customer, updated_at: "2012-04-27 14:53:59 UTC")
      create(:customer, updated_at: "2012-05-27 14:53:59 UTC")
      create(:customer, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Customer.first.updated_at

      get "/api/v1/customers/find_all?updated_at=#{updated_at}"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
      expect(customer.second["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can get one customer at random" do
      create_list(:customer, 3)
      id1 = Customer.first.id
      id2 = Customer.second.id
      id3 = Customer.third.id
      ids = [id1, id2, id3]

      get "/api/v1/customers/random"

      customer = JSON.parse(response.body)

      expect(response).to be_successful
      expect(ids).to include(customer["id"])
    end
  end

  context "Relationship Endpoints" do
    it "sends a list of invoices associated with a customer" do
      customer1 = create(:customer)
      id = customer1.id

      merchant = create(:merchant)
      customer2 = create(:customer)
      create_list(:invoice, 5, customer: customer1, merchant: merchant)
      create_list(:invoice, 5, customer: customer2, merchant: merchant)

      get "/api/v1/customers/#{id}/invoices"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)

      expect(invoices.count).to eq(5)
    end

    it "sends a list of transactions associated with a customer" do
      merchant = create(:merchant)
      customer1 = create(:customer)
      customer2 = create(:customer)
      id = customer1.id

      invoice1 = create(:invoice, customer: customer1, merchant: merchant)
      invoice2 = create(:invoice, customer: customer1, merchant: merchant)
      invoice3 = create(:invoice, customer: customer1, merchant: merchant)
      invoice4 = create(:invoice, customer: customer2, merchant: merchant)
      create(:transaction, invoice: invoice1)
      create(:transaction, invoice: invoice2)
      create(:transaction, invoice: invoice3)
      create(:transaction, invoice: invoice4)

      get "/api/v1/customers/#{id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions.count).to eq(3)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
    end
  end

end