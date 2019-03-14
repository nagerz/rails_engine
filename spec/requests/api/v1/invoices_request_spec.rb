require 'rails_helper'

describe "Invoices API" do
  context "Record Endpoints" do
    it "sends a list of invoices" do
      create_list(:invoice, 3)

      get '/api/v1/invoices'

      expect(response).to be_successful

      invoices = JSON.parse(response.body)["data"]

      expect(invoices.count).to eq(3)
    end

    it "can get one invoice by its id" do
      id = create(:invoice).id

      get "/api/v1/invoices/#{id}"

      invoice = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(invoice["id"].to_i).to eq(id)
    end

    it "can find one invoice by its id" do
      create_list(:invoice, 3)
      id = Invoice.second.id

      get "/api/v1/invoices/find?id=#{id}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice["id"]).to eq(id)
    end

    it "can find one invoice by its status" do
      create_list(:invoice, 3)
      status = Invoice.second.status

      get "/api/v1/invoices/find?status=#{status}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice["status"]).to eq(status)
    end

    it "can find one invoice by its created time" do
      create(:invoice, created_at: "2012-03-27 14:53:59 UTC")
      create(:invoice, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Invoice.second.created_at

      get "/api/v1/invoices/find?created_at=#{created_at}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice["created_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can find one invoice by its updated time" do
      create(:invoice, updated_at: "2012-03-27 14:53:59 UTC")
      create(:invoice, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Invoice.second.updated_at

      get "/api/v1/invoices/find?updated_at=#{updated_at}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    xit "can find one invoice case insensitive status" do
      create_list(:invoice, 3)
      status = Invoice.second.status
      upcased_status = status.upcase

      get "/api/v1/invoices/find?status=#{upcased_status}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice["status"]).to eq(status)
    end

    it "can find all invoices by id" do
      create_list(:invoice, 3)
      id = Invoice.second.id

      get "/api/v1/invoices/find_all?id=#{id}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice.first["id"]).to eq(id)
      expect(invoice.class).to eq(Array)
    end

    it "can find all invoices by status" do
      create_list(:invoice, 2)
      status = Invoice.second.status
      create(:invoice, status: "failed")

      get "/api/v1/invoices/find_all?status=#{status}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice.count).to eq(2)
      expect(invoice.first["status"]).to eq(status)
      expect(invoice.second["status"]).to eq(status)
    end

    it "can find all invoices by created time" do
      create(:invoice, created_at: "2012-03-27 14:53:59 UTC")
      create(:invoice, created_at: "2012-04-27 14:53:59 UTC")
      create(:invoice, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Invoice.first.created_at

      get "/api/v1/invoices/find_all?created_at=#{created_at}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice.count).to eq(2)
      expect(invoice.first["created_at"]).to eq("2012-03-27T14:53:59.000Z")
      expect(invoice.second["created_at"]).to eq("2012-03-27T14:53:59.000Z")
    end

    it "can find all invoices by updated time" do
      create(:invoice, updated_at: "2012-04-27 14:53:59 UTC")
      create(:invoice, updated_at: "2012-05-27 14:53:59 UTC")
      create(:invoice, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Invoice.first.updated_at

      get "/api/v1/invoices/find_all?updated_at=#{updated_at}"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice.count).to eq(2)
      expect(invoice.first["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
      expect(invoice.second["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can get one invoice at random" do
      create_list(:invoice, 3)
      id1 = Invoice.first.id
      id2 = Invoice.second.id
      id3 = Invoice.third.id
      ids = [id1, id2, id3]

      get "/api/v1/invoices/random"

      invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(ids).to include(invoice["id"])
    end
  end

  context "Relationship Endpoints" do
    it "sends a list of invoice_items associated with a invoice" do
      item1 = create(:item)
      item2 = create(:item)
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      id = invoice1.id

      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1)
      create(:invoice_item, item: item1, invoice: invoice2)
      create(:invoice_item, item: item2, invoice: invoice1)
      i_id = invoice_item1.id

      get "/api/v1/invoices/#{id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items.count).to eq(2)
      expect(invoice_items.first["id"]).to eq(i_id)
    end

    it "sends a list of items associated with a invoice" do
      item1 = create(:item)
      item2 = create(:item)
      i_id = item1.id

      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      id = invoice1.id

      create(:invoice_item, item: item1, invoice: invoice1)
      create(:invoice_item, item: item1, invoice: invoice2)
      create(:invoice_item, item: item2, invoice: invoice1)

      get "/api/v1/invoices/#{id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items.count).to eq(2)
      expect(items.first["id"]).to eq(i_id)
    end

    it "sends a list of transactions associated with a invoice" do
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      id = invoice1.id

      transaction1 = create(:transaction, invoice: invoice1)
      transaction2 = create(:transaction, invoice: invoice2)
      transaction3 = create(:transaction, invoice: invoice1)
      t_id1 = transaction1.id
      t_id3 = transaction3.id

      get "/api/v1/invoices/#{id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions.count).to eq(2)
      expect(transactions.first["id"]).to eq(t_id1)
      expect(transactions.second["id"]).to eq(t_id3)
    end

    it "sends a merchant associated with an invoice" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      mid = merchant1.id
      invoice1 = create(:invoice, merchant: merchant1)
      invoice2 = create(:invoice, merchant: merchant2)
      id = invoice1.id

      get "/api/v1/invoices/#{id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body)

      expect(merchant["id"]).to eq(mid)
    end

    it "sends a customer associated with an invoice" do
      customer1 = create(:customer)
      customer2 = create(:customer)
      cid = customer1.id
      invoice1 = create(:invoice, customer: customer1)
      invoice2 = create(:invoice, customer: customer2)
      id = invoice1.id

      get "/api/v1/invoices/#{id}/customer"

      expect(response).to be_successful

      customer = JSON.parse(response.body)

      expect(customer["id"]).to eq(cid)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
    end
  end

end
