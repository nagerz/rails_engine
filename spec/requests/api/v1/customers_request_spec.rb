require 'rails_helper'

describe "Customers API" do
  context "Record Endpoints" do
    it "sends a list of customers" do
      create_list(:customer, 3)

      get '/api/v1/customers'

      expect(response).to be_successful

      customers = JSON.parse(response.body)["data"]

      expect(customers.count).to eq(3)
    end

    it "can get one customer by its id" do
      id = create(:customer).id

      get "/api/v1/customers/#{id}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(id)
    end

    it "can find one customer by its id" do
      create_list(:customer, 3)
      id = Customer.second.id

      get "/api/v1/customers/find?id=#{id}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(id)
    end

    it "can find one customer by its first name" do
      create_list(:customer, 3)
      name = Customer.second.first_name

      get "/api/v1/customers/find?first_name=#{name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["first_name"]).to eq(name)
    end

    it "can find one customer by its last name" do
      create_list(:customer, 3)
      name = Customer.second.last_name

      get "/api/v1/customers/find?last_name=#{name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["attributes"]["last_name"]).to eq(name)
    end

    it "can find one customer by its created time" do
      create(:customer, created_at: "2012-03-27 14:53:59 UTC")
      create(:customer, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Customer.second.created_at
      id = Customer.second.id

      get "/api/v1/customers/find?created_at=#{created_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(id)
    end

    it "can find one customer by its updated time" do
      create(:customer, updated_at: "2012-03-27 14:53:59 UTC")
      create(:customer, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Customer.second.updated_at
      id = Customer.second.id

      get "/api/v1/customers/find?updated_at=#{updated_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["id"].to_i).to eq(id)
    end

    xit "can find one customer case insensitive name" do
      create_list(:customer, 3)
      name = Customer.second.name
      upcased_name = name.upcase

      get "/api/v1/customers/find?name=#{upcased_name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer["name"]).to eq(name)
    end

    it "can find all customers by id" do
      create_list(:customer, 3)
      id = Customer.second.id

      get "/api/v1/customers/find_all?id=#{id}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer.first["id"].to_i).to eq(id)
      expect(customer.class).to eq(Array)
    end

    it "can find all customers by first name" do
      create_list(:customer, 3)
      name = Customer.second.first_name
      create(:customer, first_name: name)

      get "/api/v1/customers/find_all?first_name=#{name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["attributes"]["first_name"]).to eq(name)
      expect(customer.second["attributes"]["first_name"]).to eq(name)
    end

    it "can find all customers by last name" do
      create_list(:customer, 3)
      name = Customer.second.last_name
      create(:customer, last_name: name)

      get "/api/v1/customers/find_all?last_name=#{name}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["attributes"]["last_name"]).to eq(name)
      expect(customer.second["attributes"]["last_name"]).to eq(name)
    end

    it "can find all customers by created time" do
      create(:customer, created_at: "2012-03-27 14:53:59 UTC")
      create(:customer, created_at: "2012-04-27 14:53:59 UTC")
      create(:customer, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Customer.first.created_at
      id1 = Customer.first.id
      id3 = Customer.third.id

      get "/api/v1/customers/find_all?created_at=#{created_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["id"].to_i).to eq(id1)
      expect(customer.second["id"].to_i).to eq(id3)
    end

    it "can find all customers by updated time" do
      create(:customer, updated_at: "2012-04-27 14:53:59 UTC")
      create(:customer, updated_at: "2012-05-27 14:53:59 UTC")
      create(:customer, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Customer.first.updated_at
      id1 = Customer.first.id
      id3 = Customer.third.id

      get "/api/v1/customers/find_all?updated_at=#{updated_at}"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(customer.count).to eq(2)
      expect(customer.first["id"].to_i).to eq(id1)
      expect(customer.second["id"].to_i).to eq(id3)
    end

    it "can get one customer at random" do
      create_list(:customer, 3)
      id1 = Customer.first.id
      id2 = Customer.second.id
      id3 = Customer.third.id
      ids = [id1, id2, id3]

      get "/api/v1/customers/random"

      customer = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(ids).to include(customer["id"].to_i)
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

      invoices = JSON.parse(response.body)["data"]

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

      transactions = JSON.parse(response.body)["data"]

      expect(transactions.count).to eq(3)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
      @c1 = create(:customer)
      @c2 = create(:customer)

      @m1 = create(:merchant)
      @m2 = create(:merchant)

      #Sucessful customer-merchant transactions
      invoice1 = create(:invoice, customer: @c1, merchant: @m1)
      invoice2 = create(:invoice, customer: @c1, merchant: @m1)

      #Customer invoices with different merchant. 2 failed transactions.
      invoice3 = create(:invoice, customer: @c1, merchant: @m2)
      invoice4 = create(:invoice, customer: @c1, merchant: @m2)
      invoice5 = create(:invoice, customer: @c1, merchant: @m2)

      #Different customer
      invoice6 = create(:invoice, customer: @c2, merchant: @m2)
      invoice7 = create(:invoice, customer: @c2, merchant: @m2)
      invoice8 = create(:invoice, customer: @c2, merchant: @m2)

      transaction1 = create(:transaction, invoice: invoice1, result: "success")
      transaction2 = create(:transaction, invoice: invoice2, result: "success")
      transaction3 = create(:transaction, invoice: invoice3, result: "success")
      transaction4 = create(:transaction, invoice: invoice4, result: "failed")
      transaction5 = create(:transaction, invoice: invoice5, result: "failed")
      transaction6 = create(:transaction, invoice: invoice6, result: "success")
      transaction7 = create(:transaction, invoice: invoice7, result: "success")
      transaction8 = create(:transaction, invoice: invoice8, result: "success")
    end

    it "sends the merchant where customer has conducted the most total number of successful transactions" do
      mid = @m1.id
      cid = @c1.id

      get "/api/v1/customers/#{cid}/favorite_merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body)["data"]

      expect(merchant["attributes"]["id"].to_i).to eq(mid)
    end
  end

end
