require 'rails_helper'

describe "Items API" do
  context "Record Endpoints" do
    it "sends a list of items" do
      create_list(:item, 3)

      get '/api/v1/items'

      expect(response).to be_successful

      items = JSON.parse(response.body)["data"]

      expect(items.count).to eq(3)
    end

    it "can get one item by its id" do
      id = create(:item).id

      get "/api/v1/items/#{id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(id)
    end

    it "can find one item by its id" do
      create_list(:item, 3)
      id = Item.second.id

      get "/api/v1/items/find?id=#{id}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["id"]).to eq(id)
    end

    it "can find one item by its name" do
      create_list(:item, 3)
      name = Item.second.name

      get "/api/v1/items/find?name=#{name}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["name"]).to eq(name)
    end

    it "can find one item by its description" do
      create_list(:item, 3)
      description = Item.second.description

      get "/api/v1/items/find?description=#{description}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["description"]).to eq(description)
    end

    it "can find one item by its created time" do
      create(:item, created_at: "2012-03-27 14:53:59 UTC")
      create(:item, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Item.second.created_at

      get "/api/v1/items/find?created_at=#{created_at}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["created_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can find one item by its updated time" do
      create(:item, updated_at: "2012-03-27 14:53:59 UTC")
      create(:item, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Item.second.updated_at

      get "/api/v1/items/find?updated_at=#{updated_at}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    xit "can find one item case insensitive name" do
      create_list(:item, 3)
      name = Item.second.name
      upcased_name = name.upcase

      get "/api/v1/items/find?name=#{upcased_name}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item["name"]).to eq(name)
    end

    it "can find all items by id" do
      create_list(:item, 3)
      id = Item.second.id

      get "/api/v1/items/find_all?id=#{id}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item.first["id"]).to eq(id)
      expect(item.class).to eq(Array)
    end

    it "can find all items by name" do
      create_list(:item, 3)
      name = Item.second.name
      create(:item, name: name)

      get "/api/v1/items/find_all?name=#{name}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["name"]).to eq(name)
      expect(item.second["name"]).to eq(name)
    end

    it "can find all items by description" do
      create_list(:item, 3)
      description = Item.second.description
      create(:item, description: description)

      get "/api/v1/items/find_all?description=#{description}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["description"]).to eq(description)
      expect(item.second["description"]).to eq(description)
    end

    it "can find all items by unit_price" do
      create_list(:item, 3)
      price = Item.second.unit_price
      create(:item, unit_price: price)

      get "/api/v1/items/find_all?unit_price=#{price}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["unit_price"]).to eq(price)
      expect(item.second["unit_price"]).to eq(price)
    end

    it "can find all items by created time" do
      create(:item, created_at: "2012-03-27 14:53:59 UTC")
      create(:item, created_at: "2012-04-27 14:53:59 UTC")
      create(:item, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Item.first.created_at

      get "/api/v1/items/find_all?created_at=#{created_at}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["created_at"]).to eq("2012-03-27T14:53:59.000Z")
      expect(item.second["created_at"]).to eq("2012-03-27T14:53:59.000Z")
    end

    it "can find all items by updated time" do
      create(:item, updated_at: "2012-04-27 14:53:59 UTC")
      create(:item, updated_at: "2012-05-27 14:53:59 UTC")
      create(:item, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Item.first.updated_at

      get "/api/v1/items/find_all?updated_at=#{updated_at}"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
      expect(item.second["updated_at"]).to eq("2012-04-27T14:53:59.000Z")
    end

    it "can get one item at random" do
      create_list(:item, 3)
      id1 = Item.first.id
      id2 = Item.second.id
      id3 = Item.third.id
      ids = [id1, id2, id3]

      get "/api/v1/items/random"

      item = JSON.parse(response.body)

      expect(response).to be_successful
      expect(ids).to include(item["id"])
    end
  end

  context "Relationship Endpoints" do
    it "sends a list of invoice_items associated with a item" do
      item1 = create(:item)
      id = item1.id

      item2 = create(:item)
      invoice1 = create(:invoice)
      invoice2 = create(:invoice)
      create(:invoice_item, item: item1, invoice: invoice1)
      create(:invoice_item, item: item1, invoice: invoice2)
      create(:invoice_item, item: item2, invoice: invoice1)

      get "/api/v1/items/#{id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items.count).to eq(2)
    end

    it "sends a merchant associated with an item" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      mid = merchant1.id
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant2)
      id = item1.id

      get "/api/v1/items/#{id}/merchant"

      expect(response).to be_successful

      merchant = JSON.parse(response.body)

      expect(merchant["id"]).to eq(mid)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
    end
  end

end
