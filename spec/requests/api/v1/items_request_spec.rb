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

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(id)
    end

    it "can find one item by its name" do
      create_list(:item, 3)
      name = Item.second.name

      get "/api/v1/items/find?name=#{name}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["name"]).to eq(name)
    end

    it "can find one item by its description" do
      create_list(:item, 3)
      description = Item.second.description

      get "/api/v1/items/find?description=#{description}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["description"]).to eq(description)
    end

    it "can find one item by its created time" do
      create(:item, created_at: "2012-03-27 14:53:59 UTC")
      create(:item, created_at: "2012-04-27 14:53:59 UTC")
      created_at = Item.second.created_at
      id = Item.second.id

      get "/api/v1/items/find?created_at=#{created_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(id)
    end

    it "can find one item by its updated time" do
      create(:item, updated_at: "2012-03-27 14:53:59 UTC")
      create(:item, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Item.second.updated_at
      id = Item.second.id

      get "/api/v1/items/find?updated_at=#{updated_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["id"].to_i).to eq(id)
    end

    xit "can find one item case insensitive name" do
      create_list(:item, 3)
      name = Item.second.name
      upcased_name = name.upcase

      get "/api/v1/items/find?name=#{upcased_name}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item["attributes"]["name"]).to eq(name)
    end

    it "can find all items by id" do
      create_list(:item, 3)
      id = Item.second.id

      get "/api/v1/items/find_all?id=#{id}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item.first["id"].to_i).to eq(id)
      expect(item.class).to eq(Array)
    end

    it "can find all items by name" do
      create_list(:item, 3)
      name = Item.second.name
      create(:item, name: name)

      get "/api/v1/items/find_all?name=#{name}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["attributes"]["name"]).to eq(name)
      expect(item.second["attributes"]["name"]).to eq(name)
    end

    it "can find all items by description" do
      create_list(:item, 3)
      description = Item.second.description
      create(:item, description: description)

      get "/api/v1/items/find_all?description=#{description}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["attributes"]["description"]).to eq(description)
      expect(item.second["attributes"]["description"]).to eq(description)
    end

    it "can find all items by unit_price" do
      create_list(:item, 3)
      price = (Item.second.unit_price/100.to_f).to_s
      create(:item, unit_price: Item.second.unit_price)

      get "/api/v1/items/find_all?unit_price=#{price}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["attributes"]["unit_price"]).to eq(price)
      expect(item.second["attributes"]["unit_price"]).to eq(price)
    end

    it "can find all items by created time" do
      create(:item, created_at: "2012-03-27 14:53:59 UTC")
      create(:item, created_at: "2012-04-27 14:53:59 UTC")
      create(:item, created_at: "2012-03-27 14:53:59 UTC")
      created_at = Item.first.created_at
      id1 = Item.first.id
      id3 = Item.third.id

      get "/api/v1/items/find_all?created_at=#{created_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["id"].to_i).to eq(id1)
      expect(item.second["id"].to_i).to eq(id3)
    end

    it "can find all items by updated time" do
      create(:item, updated_at: "2012-04-27 14:53:59 UTC")
      create(:item, updated_at: "2012-05-27 14:53:59 UTC")
      create(:item, updated_at: "2012-04-27 14:53:59 UTC")
      updated_at = Item.first.updated_at
      id1 = Item.first.id
      id3 = Item.third.id

      get "/api/v1/items/find_all?updated_at=#{updated_at}"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(item.count).to eq(2)
      expect(item.first["id"].to_i).to eq(id1)
      expect(item.second["id"].to_i).to eq(id3)
    end

    it "can get one item at random" do
      create_list(:item, 3)
      id1 = Item.first.id
      id2 = Item.second.id
      id3 = Item.third.id
      ids = [id1, id2, id3]

      get "/api/v1/items/random"

      item = JSON.parse(response.body)["data"]

      expect(response).to be_successful
      expect(ids).to include(item["id"].to_i)
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

      invoice_items = JSON.parse(response.body)["data"]

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

      merchant = JSON.parse(response.body)["data"]

      expect(merchant["id"].to_i).to eq(mid)
    end
  end

  context "Business Intelligence Endpoints" do
    before :each do
      @date1 = "2012-03-25 09:54:09 UTC"
      @date2 = "2012-03-07 09:54:09 UTC"
      @date3 = "2012-03-08 09:54:09 UTC"
      #@date4 = "2012-03-09 09:54:09 UTC"
      @date4 = "2012-03-09"

      customer1 = create(:customer)
      customer2 = create(:customer)
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      @item1 = create(:item, merchant: merchant1)
      @item2 = create(:item, merchant: merchant1)
      @item3 = create(:item, merchant: merchant2)
      @item4 = create(:item, merchant: merchant2)

      invoice1 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date1)
      invoice2 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date2)
      invoice3 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date1)
      invoice4 = create(:invoice, customer: customer1, merchant: merchant1, created_at: @date2)
      invoice5 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)
      invoice6 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)
      invoice7 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)
      invoice8 = create(:invoice, customer: customer2, merchant: merchant2, created_at: @date1)

      invoice10 = create(:invoice, customer: customer2, merchant: merchant1, created_at: @date3)
      invoice11 = create(:invoice, customer: customer2, merchant: merchant1, created_at: @date4)

      invoice12 = create(:invoice, customer: customer2, merchant: merchant2, updated_at: @date3)

      invoice_item1 = create(:invoice_item, item: @item1, invoice: invoice1, quantity: 1, unit_price: 100)
      invoice_item2 = create(:invoice_item, item: @item1, invoice: invoice2, quantity: 2, unit_price: 200)
      invoice_item3 = create(:invoice_item, item: @item2, invoice: invoice3, quantity: 3, unit_price: 300)
      invoice_item4 = create(:invoice_item, item: @item2, invoice: invoice4, quantity: 4, unit_price: 400)
      invoice_item5 = create(:invoice_item, item: @item3, invoice: invoice5, quantity: 5, unit_price: 500)
      invoice_item6 = create(:invoice_item, item: @item3, invoice: invoice6, quantity: 6, unit_price: 600)
      invoice_item7 = create(:invoice_item, item: @item4, invoice: invoice7, quantity: 7, unit_price: 700)
      invoice_item8 = create(:invoice_item, item: @item4, invoice: invoice8, quantity: 8, unit_price: 800)
      invoice_item9 = create(:invoice_item, item: @item1, invoice: invoice1, quantity: 1, unit_price: 100)
      invoice_item10 = create(:invoice_item, item: @item1, invoice: invoice10, quantity: 2, unit_price: 600)
      invoice_item11 = create(:invoice_item, item: @item1, invoice: invoice11, quantity: 2, unit_price: 600)

      invoice_item12 = create(:invoice_item, item: @item2, invoice: invoice12, quantity: 100, unit_price: 10000)

      transaction1 = create(:transaction, invoice: invoice1, result: "success")
      transaction2 = create(:transaction, invoice: invoice2, result: "success")
      transaction3 = create(:transaction, invoice: invoice3, result: "success")
      transaction4 = create(:transaction, invoice: invoice4, result: "success")
      transaction5 = create(:transaction, invoice: invoice5, result: "success")
      transaction6 = create(:transaction, invoice: invoice6, result: "success")
      transaction7 = create(:transaction, invoice: invoice7, result: "success")
      transaction8 = create(:transaction, invoice: invoice8, result: "success")
      transaction10 = create(:transaction, invoice: invoice10, result: "success")
      transaction11 = create(:transaction, invoice: invoice11, result: "success")

      transaction12 = create(:transaction, invoice: invoice12, result: "failed")
    end

    it "sends the top items ranked by total revenue" do
      x = 3

      get "/api/v1/items/most_revenue?quantity=#{x}"

      expect(response).to be_successful

      items = JSON.parse(response.body)["data"]

      expect(items.count).to eq(3)
      expect(items[0]["attributes"]["name"]).to eq(@item4.name)
      expect(items[1]["attributes"]["name"]).to eq(@item3.name)
      expect(items[2]["attributes"]["name"]).to eq(@item1.name)
    end

    it "sends the top items ranked by total quantity" do
      x = 3

      get "/api/v1/items/most_items?quantity=#{x}"

      expect(response).to be_successful

      items = JSON.parse(response.body)["data"]

      expect(items.count).to eq(3)
      expect(items[0]["attributes"]["name"]).to eq(@item4.name)
      expect(items[1]["attributes"]["name"]).to eq(@item3.name)
      expect(items[2]["attributes"]["name"]).to eq(@item1.name)
    end

    it "sends the date with the most sales for a given item" do
      id1 = @item1.id
      id2 = @item2.id

      get "/api/v1/items/#{id1}/best_day"

      expect(response).to be_successful

      date = JSON.parse(response.body)["data"]["attributes"]["best_day"]

      expect(date).to eq(@date4)

      get "/api/v1/items/#{id2}/best_day"

      expect(response).to be_successful

      date = JSON.parse(response.body)["data"]["attributes"]["best_day"]

      expect(date).to eq(@date2)
    end
  end

end
