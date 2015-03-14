require 'rails_helper'

describe Invoice do
  it 'has a valid factory' do
    FactoryGirl.create(:invoice).should be_valid
  end
  it 'is invalid without a number' do
    FactoryGirl.build(:invoice, number: nil).should_not be_valid
  end
  it 'does not allow duplicate invoice number' do
    FactoryGirl.create(:invoice, number: 'INV030' )
    FactoryGirl.build(:invoice, number: 'INV030' ).should_not be_valid
  end
end