require 'rails_helper'

describe "Transactions API" do
  context "Record Endpoints" do
    it "sends a list of transactions" do
      create_list(:transaction, 3)

      get '/api/v1/transactions'

      expect(response).to be_successful

      transactions = JSON.parse(response.body)["data"]

      expect(transactions.count).to eq(3)
    end

    it "can get one transaction by its id" do
      id = create(:transaction).id

      get "/api/v1/transactions/#{id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(id)
    end

    it "can find one transaction by its id" do
      create_list(:transaction, 3)
      id = Transaction.second.id

      get "/api/v1/transactions/find?id=#{id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(id)
    end

    it "can find one transaction by its result" do
      create_list(:transaction, 3)
      result = Transaction.second.result

      get "/api/v1/transactions/find?result=#{result}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["result"]).to eq(result)
    end

    it "can find one transaction by its credit_card_number" do
      create_list(:transaction, 3)
      credit_card_number = Transaction.second.credit_card_number.to_s

      get "/api/v1/transactions/find?credit_card_number=#{credit_card_number}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["attributes"]["credit_card_number"]).to eq(credit_card_number)
    end

    it "can find one transaction by its created time" do
      create(:transaction, created_at: "2012-03-27 14:53:59 UTC")
      create(:transaction, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Transaction.second.created_at
      id = Transaction.second.id

      get "/api/v1/transactions/find?created_at=#{created_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(id)
    end

    it "can find one transaction by its updated time" do
      create(:transaction, updated_at: "2012-03-27 14:53:59 UTC")
      create(:transaction, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Transaction.second.updated_at
      id = Transaction.second.id

      get "/api/v1/transactions/find?updated_at=#{updated_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["id"].to_i).to eq(id)
    end

    xit "can find one transaction case insensitive result" do
      create_list(:transaction, 3)
      result = Transaction.second.result
      upcased_result = result.upcase

      get "/api/v1/transactions/find?result=#{upcased_result}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction["result"]).to eq(result)
    end

    it "can find all transactions by id" do
      create_list(:transaction, 3)
      id = Transaction.second.id

      get "/api/v1/transactions/find_all?id=#{id}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction.first["id"].to_i).to eq(id)
      expect(transaction.class).to eq(Array)
    end

    it "can find all transactions by result" do
      create_list(:transaction, 2)
      result = Transaction.second.result
      create(:transaction, result: "failed")

      get "/api/v1/transactions/find_all?result=#{result}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction.count).to eq(2)
      expect(transaction.first["attributes"]["result"]).to eq(result)
      expect(transaction.second["attributes"]["result"]).to eq(result)
    end

    it "can find all transactions by credit_card_number" do
      create_list(:transaction, 3)
      credit_card_number = Transaction.second.credit_card_number.to_s
      create(:transaction, credit_card_number: credit_card_number)

      get "/api/v1/transactions/find_all?credit_card_number=#{credit_card_number}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction.count).to eq(2)
      expect(transaction.first["attributes"]["credit_card_number"]).to eq(credit_card_number)
      expect(transaction.second["attributes"]["credit_card_number"]).to eq(credit_card_number)
    end

    it "can find all transactions by created time" do
      create(:transaction, created_at: "2012-03-27 14:53:59 UTC")
      create(:transaction, created_at: "2012-04-27 14:53:59 UTC")
      create(:transaction, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Transaction.first.created_at
      id1 = Transaction.first.id
      id3 = Transaction.third.id

      get "/api/v1/transactions/find_all?created_at=#{created_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction.count).to eq(2)
      expect(transaction.first["id"].to_i).to eq(id1)
      expect(transaction.second["id"].to_i).to eq(id3)
    end

    it "can find all transactions by updated time" do
      create(:transaction, updated_at: "2012-04-27 14:53:59 UTC")
      create(:transaction, updated_at: "2012-05-27 14:53:59 UTC")
      create(:transaction, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Transaction.first.updated_at
      id1 = Transaction.first.id
      id3 = Transaction.third.id

      get "/api/v1/transactions/find_all?updated_at=#{updated_at}"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(transaction.count).to eq(2)
      expect(transaction.first["id"].to_i).to eq(id1)
      expect(transaction.second["id"].to_i).to eq(id3)
    end

    it "can get one transaction at random" do
      create_list(:transaction, 3)
      id1 = Transaction.first.id
      id2 = Transaction.second.id
      id3 = Transaction.third.id
      ids = [id1, id2, id3]

      get "/api/v1/transactions/random"

      transaction = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(ids).to include(transaction["id"].to_i)
    end
  end

  context "Relationship Endpoints" do
    it "sends the invoice associated with a transaction" do
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      i_id = invoice1.id
      transaction1 = create(:transaction, invoice: invoice1)
      transaction2 = create(:transaction, invoice: invoice2)
      id = transaction1.id

      get "/api/v1/transactions/#{id}/invoice"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["id"]).to eq(i_id)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
    end
  end

end
