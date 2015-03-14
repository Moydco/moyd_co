FactoryGirl.define do
  factory :user do |f|
    f.email {Faker::Internet.email}
    f.first_name {Faker::Name.first_name}
    f.last_name  {Faker::Name.last_name}
    f.quickbooks_id {Faker::Code.ean}
    f.opt_in '1'
  end

  factory :invalid_user, parent: :user do |f|
    f.email {Faker::Internet.email}
    f.first_name nil
    f.last_name  {Faker::Name.last_name}
    f.quickbooks_id {Faker::Code.ean}
    f.opt_in '1'
  end

  factory :user_no_opt_in, parent: :user do |f|
    f.email {Faker::Internet.email}
    f.first_name {Faker::Name.first_name}
    f.last_name  {Faker::Name.last_name}
    f.quickbooks_id {Faker::Code.ean}
    f.opt_in '0'
  end

  factory :admin_user, parent: :user do |f|
    f.email {Faker::Internet.email}
    f.first_name {Faker::Name.first_name}
    f.last_name  {Faker::Name.last_name}
    f.quickbooks_id {Faker::Code.ean}
    f.admin true
  end
end