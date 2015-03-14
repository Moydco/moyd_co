FactoryGirl.define do
  factory :subscription do |f|
    f.product {Faker::Commerce.product_name}
    f.description {Faker::Lorem.words(4)}
    f.rate {Faker::Commerce.price}
    f.month {Faker::Number.digit}
  end
end