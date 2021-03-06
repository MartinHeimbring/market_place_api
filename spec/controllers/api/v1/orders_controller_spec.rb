require 'rails_helper'

describe Api::V1::OrdersController do

  describe "GET #index" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      4.times { FactoryGirl.create :order, user: current_user }
      get :index, user_id: current_user.id
    end

    it "returns 4 order records from the user" do
      orders_response = json_response[:orders]
      expect((orders_response).count).to eq 4
    end

    it { expect(json_response).to have_key(:meta) }
    it { expect(json_response[:meta]).to have_key(:pagination) }
    it { expect(json_response[:meta][:pagination]).to have_key(:per_page) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_pages) }
    it { expect(json_response[:meta][:pagination]).to have_key(:total_objects) }

    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token
      @product = FactoryGirl.create :product
      @order = FactoryGirl.create :order, user: current_user#, product_ids: [@product.id]
      get :show, user_id: current_user.id, id: @order.id
    end

    it "returns the user order record matching the id" do
      p @product
      order_response = json_response[:order]
      expect(order_response[:id]).to eq @order.id
    end

    it { should respond_with 200 }

    it "includes the total for the order" do
      order_response = json_response[:order]
      expect(order_response[:total]).to eql @order.total.to_s
    end

    it "includes the products on the order" do
      skip
      order_response = json_response[:order]
      expect((order_response[:products]).count).to eq 1
    end

  end

  describe "POST #create" do
    before(:each) do
      current_user = FactoryGirl.create :user
      api_authorization_header current_user.auth_token

      product_1 = FactoryGirl.create :product
      product_2 = FactoryGirl.create :product
      order_params = { product_ids_and_quantities: [[product_1.id, 2],[ product_2.id, 3]] }
      post :create, user_id: current_user.id, order: order_params
    end

    it "returns the user order record" do
      order_response = json_response[:order]
      expect(order_response[:id]).to be_present
    end

    it { should respond_with 201 }
  end


end

