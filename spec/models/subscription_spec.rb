require 'rails_helper'

describe Subscription do
  it 'has a valid factory' do
    FactoryGirl.create(:subscription).should be_valid
  end
  it 'is invalid without a product' do
    FactoryGirl.build(:subscription, product: nil).should_not be_valid
  end
  it 'is invalid without a description' do
    FactoryGirl.build(:subscription, description: nil).should_not be_valid
  end
  it 'is invalid without a rate' do
    FactoryGirl.build(:subscription, rate: nil).should_not be_valid
  end
  it 'is invalid without a correct item type' do
    FactoryGirl.build(:subscription, item_type: 'xxxx').should_not be_valid
  end
  it 'is invalid without a correct month' do
    FactoryGirl.build(:subscription, month: 13).should_not be_valid
  end
end