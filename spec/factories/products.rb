FactoryGirl.define do
  factory :product do
    title { Faker::Product.product_name }
    price { rand() * 100 }
    published false
    quantity 5
    user
  end
end
