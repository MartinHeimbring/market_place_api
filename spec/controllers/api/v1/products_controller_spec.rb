require 'rails_helper'

describe Api::V1::ProductsController do
  describe "GET #show" do
    before(:each) do
      FactoryGirl.create :user
      @product = FactoryGirl.create :product
      get :show, id: @product.id
    end

    it "returns the information about a repoter on a hash" do
      product_response = json_response[:product]
      expect(product_response[:title]).to eq @product.title
    end

    it { should respond_with 200}

    it "has the user as an embeded object" do
      product_response = json_response[:product]
      p product_response
      expect(product_response[:user][:email]).to eq @product.user.email
    end
  end

  describe "GET #index" do
    before(:each) do
      FactoryGirl.create :user
      4.times { FactoryGirl.create :product }
      get :index
    end

    it "returns 4 records from the database" do
      products_response = json_response
      expect(products_response[:products].count).to eq 4
    end

    it { should respond_with 200 }

    it "returns the user object into each product" do
      products_response = json_response[:products]
      products_response.each do |product_response|
        expect(product_response[:user]).to be_present
      end
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        user = FactoryGirl.create :user
        @product_attributes = FactoryGirl.attributes_for :product
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @product_attributes }
      end

      it "renders the json representation for the product record just created" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq @product_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        user = FactoryGirl.create :user
        @invalid_product_attributes = { title: "Smart TV", price: "Twelve dollars" }
        api_authorization_header user.auth_token
        post :create, { user_id: user.id, product: @invalid_product_attributes }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on why the product could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id,
                         product: { title: "An expensive TV" } }
      end

      it "renders the json representaiton for the updated product" do
        product_response = json_response[:product]
        expect(product_response[:title]).to eq "An expensive TV"
      end

      it { should respond_with 200 }
    end

    context "when is not updated" do
      before(:each) do
        patch :update, { user_id: @user.id, id: @product.id,
                     product: { price: "two hundred" } }
      end

      it "renders an errors json" do
        product_response = json_response
        expect(product_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        product_response = json_response
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      @product = FactoryGirl.create :product, user: @user
      api_authorization_header @user.auth_token
      delete :destroy, { user_id: @user.id, id: @product.id }
    end

    it { should respond_with 204 }
  end
end
