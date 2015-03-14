FactoryGirl.define do
  factory :invoice do |f|
    f.number {Faker::Code.ean}
  end
end