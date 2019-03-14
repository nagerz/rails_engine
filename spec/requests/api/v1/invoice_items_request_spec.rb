require 'rails_helper'

describe "Invoice_items API" do
  context "Record Endpoints" do
    it "sends a list of invoice_items" do
      create_list(:invoice_item, 3)

      get '/api/v1/invoice_items'

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items.count).to eq(3)
    end

    it "can get one invoice_item by its id" do
      id = create(:invoice_item).id

      get "/api/v1/invoice_items/#{id}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item["id"]).to eq(id)
    end

    it "can find one invoice_item by its id" do
      create_list(:invoice_item, 3)
      id = InvoiceItem.second.id

      get "/api/v1/invoice_items/find?id=#{id}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item["id"]).to eq(id)
    end

    it "can find one invoice_item by its quantity" do
      create_list(:invoice_item, 3)
      quantity = InvoiceItem.second.quantity

      get "/api/v1/invoice_items/find?quantity=#{quantity}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item["quantity"]).to eq(quantity)
    end

    it "can find one invoice_item by its unit_price" do
      create_list(:invoice_item, 3)
      unit_price = InvoiceItem.second.unit_price

      get "/api/v1/invoice_items/find?unit_price=#{unit_price}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item["unit_price"]).to eq(unit_price)
    end

    it "can find one invoice_item by its created time" do
      create(:invoice_item, created_at: "2012-03-27 14:53:59 UTC")
      create(:invoice_item, created_at: "2012-04-27 14:53:59 UTC")
      created_at = InvoiceItem.second.created_at

      get "/api/v1/invoice_items/find?created_at=#{created_at}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item["created_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can find one invoice_item by its updated time" do
      create(:invoice_item, updated_at: "2012-03-27 14:53:59 UTC")
      create(:invoice_item, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = InvoiceItem.second.updated_at

      get "/api/v1/invoice_items/find?updated_at=#{updated_at}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can find all invoice_items by id" do
      create_list(:invoice_item, 3)
      id = InvoiceItem.second.id

      get "/api/v1/invoice_items/find_all?id=#{id}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item.first["id"]).to eq(id)
      expect(invoice_item.class).to eq(Array)
    end

    it "can find all invoice_items by quantity" do
      create_list(:invoice_item, 3)
      quantity = InvoiceItem.second.quantity
      create(:invoice_item, quantity: quantity)

      get "/api/v1/invoice_items/find_all?quantity=#{quantity}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item.count).to eq(2)
      expect(invoice_item.first["quantity"]).to eq(quantity)
      expect(invoice_item.second["quantity"]).to eq(quantity)
    end

    it "can find all invoice_items by unit_price" do
      create_list(:invoice_item, 3)
      price = InvoiceItem.second.unit_price
      create(:invoice_item, unit_price: price)

      get "/api/v1/invoice_items/find_all?unit_price=#{price}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item.count).to eq(2)
      expect(invoice_item.first["unit_price"]).to eq(price)
      expect(invoice_item.second["unit_price"]).to eq(price)
    end

    it "can find all invoice_items by created time" do
      create(:invoice_item, created_at: "2012-03-27 14:53:59 UTC")
      create(:invoice_item, created_at: "2012-04-27 14:53:59 UTC")
      create(:invoice_item, created_at: "2012-03-27 14:53:59 UTC")
      created_at = InvoiceItem.first.created_at

      get "/api/v1/invoice_items/find_all?created_at=#{created_at}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item.count).to eq(2)
      expect(invoice_item.first["created_at"]).to eq("2012-03-27T14:53:59.000Z")
      expect(invoice_item.second["created_at"]).to eq("2012-03-27T14:53:59.000Z")
    end

    it "can find all invoice_items by updated time" do
      create(:invoice_item, updated_at: "2012-04-27 14:53:59 UTC")
      create(:invoice_item, updated_at: "2012-05-27 14:53:59 UTC")
      create(:invoice_item, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = InvoiceItem.first.updated_at

      get "/api/v1/invoice_items/find_all?updated_at=#{updated_at}"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(invoice_item.count).to eq(2)
      expect(invoice_item.first["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
      expect(invoice_item.second["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can get one invoice_item at random" do
      create_list(:invoice_item, 3)
      id1 = InvoiceItem.first.id
      id2 = InvoiceItem.second.id
      id3 = InvoiceItem.third.id
      ids = [id1, id2, id3]

      get "/api/v1/invoice_items/random"

      invoice_item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(ids).to include(invoice_item["id"])
    end
  end

  context "Relationship Endpoints" do
    it "sends the invoice associated with a invoice_item" do
      item1 = create(:item)
      item2 = create(:item)
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      invoice_item = create(:invoice_item, item: item1, invoice: invoice1)
      id = invoice_item.id
      i_id = invoice1.id

      get "/api/v1/invoice_items/#{id}/invoice"

      expect(response).to be_successful

      invoice = JSON.parse(response.body)

      expect(invoice["id"]).to eq(i_id)
    end

    it "sends the item associated with a invoice_item" do
      item1 = create(:item)
      item2 = create(:item)
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      invoice_item = create(:invoice_item, item: item1, invoice: invoice1)
      id = invoice_item.id
      i_id = item1.id

      get "/api/v1/invoice_items/#{id}/item"

      expect(response).to be_successful

      item = JSON.parse(response.body)

      expect(item["id"]).to eq(i_id)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
    end
  end

end
